import { useEffect, useState, useCallback, useRef } from 'react';
import { useLocation, useSearch } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { ProductCard, ProductCardSkeleton, type ProductCardDTO } from '@/components/ProductCard';
import { Search, ChevronLeft, ChevronRight, SlidersHorizontal, X } from 'lucide-react';

interface Category { id: string; name_en: string; slug: string; parent_id: string | null; }
interface Brand { id: string; name_en: string; slug: string; }

function parseSearch(search: string) {
  const params = new URLSearchParams(search.startsWith('?') ? search.slice(1) : search);
  return {
    q: params.get('q') ?? '',
    category: params.get('category') ?? '',
    brand: params.get('brand') ?? '',
    sort: params.get('sort') ?? 'newest',
    page: parseInt(params.get('page') ?? '1', 10) || 1,
    minPrice: params.get('minPrice') ?? '',
    maxPrice: params.get('maxPrice') ?? '',
    inStock: params.get('inStock') === 'true',
  };
}

// avg_rating and review_count are not columns in the products table;
// they are aggregated from the reviews table separately when needed.
const PRODUCT_SELECT = `id, slug, sku, name_en, base_price, sale_price, stock_quantity, reserved_quantity, is_featured, images:product_images(url), brand:brands(name_en, slug), category:categories(name_en, slug)`;

interface ProductRow {
  id: string; slug: string; sku: string; name_en: string;
  base_price: number; sale_price: number | null;
  stock_quantity: number; reserved_quantity: number;
  is_featured: boolean;
  images: { url: string }[];
  brand: { name_en: string; slug: string } | null;
  category: { name_en: string; slug: string } | null;
}

function toProductDTO(p: ProductRow): ProductCardDTO {
  const available = (p.stock_quantity ?? 0) - (p.reserved_quantity ?? 0);
  return {
    id: p.id, slug: p.slug, sku: p.sku, name: p.name_en,
    brandName: p.brand?.name_en ?? null, categoryName: p.category?.name_en ?? null,
    imageUrl: p.images?.[0]?.url ?? null,
    basePrice: p.base_price, salePrice: p.sale_price,
    rating: 0, reviewCount: 0,
    inStock: available > 0, isFeatured: p.is_featured,
  };
}

const PAGE_SIZE = 24;

export default function ProductsPage() {
  const [, navigate] = useLocation();
  const search = useSearch();
  const filters = parseSearch(search);

  const [products, setProducts] = useState<ProductCardDTO[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState<Category[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [showFilters, setShowFilters] = useState(false);

  // Local price state so inputs don't re-fetch on every keystroke
  const [localMin, setLocalMin] = useState(filters.minPrice);
  const [localMax, setLocalMax] = useState(filters.maxPrice);
  const priceApplied = useRef(false);

  // Sync local price state when URL changes externally (e.g. clear filters)
  useEffect(() => {
    if (!priceApplied.current) {
      setLocalMin(filters.minPrice);
      setLocalMax(filters.maxPrice);
    }
    priceApplied.current = false;
  }, [search]);

  const supabase = getSupabaseClient();

  useEffect(() => {
    Promise.all([
      supabase.from('categories').select('id, name_en, slug, parent_id').eq('is_active', true).is('deleted_at', null).order('sort_order'),
      supabase.from('brands').select('id, name_en, slug').eq('is_active', true).is('deleted_at', null).order('name_en'),
    ]).then(([catRes, brandRes]) => {
      setCategories(catRes.data ?? []);
      setBrands(brandRes.data ?? []);
    });
  }, []);

  const loadProducts = useCallback(async () => {
    setLoading(true);
    const { q, category, brand, sort, page, minPrice, maxPrice, inStock } = parseSearch(search);

    // Resolve category/brand slugs to IDs for server-side filtering
    const [catRow, brandRow]: [{ data: { id: string } | null }, { data: { id: string } | null }] = await Promise.all([
      category
        ? supabase.from('categories').select('id').eq('slug', category).single()
        : Promise.resolve({ data: null as { id: string } | null }),
      brand
        ? supabase.from('brands').select('id').eq('slug', brand).single()
        : Promise.resolve({ data: null as { id: string } | null }),
    ]);

    let query = supabase
      .from('products')
      .select(PRODUCT_SELECT, { count: 'exact' })
      .eq('is_active', true)
      .is('deleted_at', null);

    if (q) query = query.ilike('name_en', `%${q}%`);
    if (catRow.data) query = query.eq('category_id', catRow.data.id);
    if (brandRow.data) query = query.eq('brand_id', brandRow.data.id);
    if (minPrice) query = query.gte('base_price', parseFloat(minPrice));
    if (maxPrice) query = query.lte('base_price', parseFloat(maxPrice));
    // In-stock pre-filter: PostgREST does not support cross-column arithmetic
    // (stock_quantity - reserved_quantity), so we exclude rows with zero stock
    // server-side and then apply the exact available-stock check client-side.
    if (inStock) query = query.gt('stock_quantity', 0);

    if (sort === 'price_asc') query = query.order('base_price', { ascending: true });
    else if (sort === 'price_desc') query = query.order('base_price', { ascending: false });
    else if (sort === 'featured') query = query.eq('is_featured', true).order('created_at', { ascending: false });
    else query = query.order('created_at', { ascending: false });

    const from = (page - 1) * PAGE_SIZE;
    query = query.range(from, from + PAGE_SIZE - 1);

    const { data, count } = await query;
    // Client-side exact available-stock check: removes fully-reserved items
    // that passed the server-side stock_quantity > 0 pre-filter.
    // Server count is used for pagination so page numbers remain correct.
    const mapped = ((data ?? []) as ProductRow[]).map(toProductDTO);
    const filtered = inStock ? mapped.filter((p) => p.inStock) : mapped;
    setProducts(filtered);
    setTotal(count ?? 0);
    setLoading(false);
  }, [search]);

  useEffect(() => {
    loadProducts();
  }, [loadProducts]);

  // Build a new URL by merging a key/value into current search params.
  // Uses the reactive `search` value (not window.location.search) to avoid stale state.
  const setFilter = useCallback((key: string, value: string) => {
    const params = new URLSearchParams(search.startsWith('?') ? search.slice(1) : search);
    if (value) params.set(key, value);
    else params.delete(key);
    params.delete('page');
    navigate(`/products?${params.toString()}`);
  }, [search, navigate]);

  const applyPriceFilter = () => {
    priceApplied.current = true;
    const params = new URLSearchParams(search.startsWith('?') ? search.slice(1) : search);
    if (localMin) params.set('minPrice', localMin); else params.delete('minPrice');
    if (localMax) params.set('maxPrice', localMax); else params.delete('maxPrice');
    params.delete('page');
    navigate(`/products?${params.toString()}`);
  };

  const clearAllFilters = () => {
    priceApplied.current = true;
    setLocalMin('');
    setLocalMax('');
    const params = new URLSearchParams();
    if (filters.q) params.set('q', filters.q);
    navigate(`/products${params.toString() ? `?${params.toString()}` : ''}`);
  };

  const totalPages = Math.ceil(total / PAGE_SIZE);

  const activeFilterCount = [
    filters.category,
    filters.brand,
    filters.minPrice,
    filters.maxPrice,
    filters.inStock ? 'inStock' : '',
  ].filter(Boolean).length;

  const hasActiveFilters = activeFilterCount > 0;

  const topCategories = categories.filter((c) => !c.parent_id);

  return (
    <div className="container-nest py-6">
      {/* Header row */}
      <div className="flex items-center justify-between mb-4">
        <div>
          <h1 className="text-xl font-heading font-semibold text-slate-900">
            {filters.q ? `Results for "${filters.q}"` : 'All Products'}
          </h1>
          <p className="text-xs text-slate-500 mt-0.5">{total} products</p>
        </div>
        <div className="flex items-center gap-2">
          {/* Sort dropdown */}
          <select
            value={filters.sort}
            onChange={(e) => setFilter('sort', e.target.value)}
            className="text-sm border border-slate-200 rounded-md px-3 py-1.5 bg-white focus:outline-none focus:border-blue-500"
            aria-label="Sort products"
          >
            <option value="newest">Newest</option>
            <option value="featured">Featured</option>
            <option value="price_asc">Price: Low to High</option>
            <option value="price_desc">Price: High to Low</option>
          </select>

          {/* Filters toggle (mobile/tablet) */}
          <button
            onClick={() => setShowFilters(!showFilters)}
            className="relative flex items-center gap-1.5 text-sm border border-slate-200 rounded-md px-3 py-1.5 bg-white hover:bg-slate-50 transition-colors lg:hidden"
            aria-expanded={showFilters}
            aria-label="Toggle filters"
          >
            <SlidersHorizontal className="w-4 h-4" />
            Filters
            {activeFilterCount > 0 && (
              <span className="absolute -top-1.5 -right-1.5 flex h-4 w-4 items-center justify-center rounded-full bg-blue-600 text-[10px] font-bold text-white">
                {activeFilterCount}
              </span>
            )}
          </button>

          {/* Clear filters */}
          {hasActiveFilters && (
            <button
              onClick={clearAllFilters}
              className="flex items-center gap-1 text-xs text-red-500 hover:text-red-600 transition-colors"
            >
              <X className="w-3 h-3" />
              Clear
            </button>
          )}
        </div>
      </div>

      <div className="flex gap-6">
        {/* Sidebar Filters */}
        <aside className={`${showFilters ? 'block' : 'hidden'} lg:block w-52 shrink-0`}>
          <div className="bg-white border border-slate-200 rounded-lg p-4 space-y-5 sticky top-32">

            {/* Category */}
            <div>
              <h3 className="text-sm font-semibold text-slate-900 mb-2">Category</h3>
              <div className="space-y-0.5">
                <button
                  onClick={() => setFilter('category', '')}
                  className={`w-full text-left text-sm px-2 py-1.5 rounded transition-colors ${!filters.category ? 'text-blue-600 font-medium bg-blue-50' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-50'}`}
                >
                  All Categories
                </button>
                {topCategories.map((cat) => (
                  <button
                    key={cat.id}
                    onClick={() => setFilter('category', cat.slug)}
                    className={`w-full text-left text-sm px-2 py-1.5 rounded transition-colors ${filters.category === cat.slug ? 'text-blue-600 font-medium bg-blue-50' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-50'}`}
                  >
                    {cat.name_en}
                  </button>
                ))}
              </div>
            </div>

            {/* Brand */}
            <div>
              <h3 className="text-sm font-semibold text-slate-900 mb-2">Brand</h3>
              <div className="space-y-0.5 max-h-52 overflow-y-auto">
                <button
                  onClick={() => setFilter('brand', '')}
                  className={`w-full text-left text-sm px-2 py-1.5 rounded transition-colors ${!filters.brand ? 'text-blue-600 font-medium bg-blue-50' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-50'}`}
                >
                  All Brands
                </button>
                {brands.map((brand) => (
                  <button
                    key={brand.id}
                    onClick={() => setFilter('brand', brand.slug)}
                    className={`w-full text-left text-sm px-2 py-1.5 rounded transition-colors ${filters.brand === brand.slug ? 'text-blue-600 font-medium bg-blue-50' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-50'}`}
                  >
                    {brand.name_en}
                  </button>
                ))}
              </div>
            </div>

            {/* Price Range */}
            <div>
              <h3 className="text-sm font-semibold text-slate-900 mb-2">Price (EGP)</h3>
              <div className="flex gap-2 mb-2">
                <input
                  type="number"
                  min={0}
                  placeholder="Min"
                  value={localMin}
                  onChange={(e) => setLocalMin(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && applyPriceFilter()}
                  className="w-full border border-slate-200 rounded px-2 py-1.5 text-sm focus:outline-none focus:border-blue-500"
                  aria-label="Minimum price"
                />
                <input
                  type="number"
                  min={0}
                  placeholder="Max"
                  value={localMax}
                  onChange={(e) => setLocalMax(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && applyPriceFilter()}
                  className="w-full border border-slate-200 rounded px-2 py-1.5 text-sm focus:outline-none focus:border-blue-500"
                  aria-label="Maximum price"
                />
              </div>
              <button
                onClick={applyPriceFilter}
                className="w-full text-xs bg-slate-100 hover:bg-slate-200 text-slate-700 rounded py-1.5 transition-colors font-medium"
              >
                Apply Price
              </button>
            </div>

            {/* In Stock */}
            <label className="flex items-center gap-2 cursor-pointer select-none">
              <input
                type="checkbox"
                checked={filters.inStock}
                onChange={(e) => setFilter('inStock', e.target.checked ? 'true' : '')}
                className="rounded border-slate-300 accent-blue-600"
              />
              <span className="text-sm text-slate-700">In stock only</span>
            </label>

            {/* Clear filters (inside sidebar) */}
            {hasActiveFilters && (
              <button
                onClick={clearAllFilters}
                className="w-full text-xs text-red-500 hover:text-red-600 border border-red-100 hover:border-red-200 rounded py-1.5 transition-colors"
              >
                Clear all filters
              </button>
            )}
          </div>
        </aside>

        {/* Products Grid */}
        <div className="flex-1 min-w-0">
          {/* Active filter chips */}
          {hasActiveFilters && (
            <div className="flex flex-wrap gap-1.5 mb-4">
              {filters.category && (
                <FilterChip label={`Category: ${categories.find((c) => c.slug === filters.category)?.name_en ?? filters.category}`} onRemove={() => setFilter('category', '')} />
              )}
              {filters.brand && (
                <FilterChip label={`Brand: ${brands.find((b) => b.slug === filters.brand)?.name_en ?? filters.brand}`} onRemove={() => setFilter('brand', '')} />
              )}
              {filters.minPrice && (
                <FilterChip label={`Min: EGP ${filters.minPrice}`} onRemove={() => { setLocalMin(''); priceApplied.current = true; setFilter('minPrice', ''); }} />
              )}
              {filters.maxPrice && (
                <FilterChip label={`Max: EGP ${filters.maxPrice}`} onRemove={() => { setLocalMax(''); priceApplied.current = true; setFilter('maxPrice', ''); }} />
              )}
              {filters.inStock && (
                <FilterChip label="In stock" onRemove={() => setFilter('inStock', '')} />
              )}
            </div>
          )}

          {loading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
              {Array.from({ length: 12 }).map((_, i) => <ProductCardSkeleton key={i} />)}
            </div>
          ) : products.length === 0 ? (
            <div className="text-center py-20 border border-slate-200 rounded-lg bg-white">
              <Search className="w-10 h-10 text-slate-300 mx-auto mb-3" />
              <h2 className="text-lg font-semibold text-slate-900 mb-1">No products found</h2>
              <p className="text-slate-500 text-sm mb-4">Try adjusting your filters or search terms.</p>
              {hasActiveFilters && (
                <button onClick={clearAllFilters} className="text-sm text-blue-600 hover:underline">
                  Clear all filters
                </button>
              )}
            </div>
          ) : (
            <>
              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
                {products.map((product) => <ProductCard key={product.id} product={product} />)}
              </div>

              {totalPages > 1 && (
                <div className="flex items-center justify-center gap-1 mt-8">
                  {filters.page > 1 && (
                    <button
                      onClick={() => setFilter('page', String(filters.page - 1))}
                      className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100 transition-colors"
                      aria-label="Previous page"
                    >
                      <ChevronLeft className="w-4 h-4" />
                    </button>
                  )}
                  {Array.from({ length: totalPages }, (_, i) => i + 1)
                    .filter((p) => p === 1 || p === totalPages || Math.abs(p - filters.page) <= 2)
                    .map((p, idx, arr) => (
                      <span key={p} className="contents">
                        {idx > 0 && arr[idx - 1] !== p - 1 && (
                          <span className="text-slate-400 text-sm px-1">…</span>
                        )}
                        <button
                          onClick={() => setFilter('page', String(p))}
                          className={`flex h-8 w-8 items-center justify-center rounded text-xs font-medium transition-colors ${p === filters.page ? 'bg-blue-600 text-white' : 'text-slate-500 hover:bg-slate-100'}`}
                          aria-label={`Page ${p}`}
                          aria-current={p === filters.page ? 'page' : undefined}
                        >
                          {p}
                        </button>
                      </span>
                    ))}
                  {filters.page < totalPages && (
                    <button
                      onClick={() => setFilter('page', String(filters.page + 1))}
                      className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100 transition-colors"
                      aria-label="Next page"
                    >
                      <ChevronRight className="w-4 h-4" />
                    </button>
                  )}
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}

function FilterChip({ label, onRemove }: { label: string; onRemove: () => void }) {
  return (
    <span className="inline-flex items-center gap-1 text-xs bg-blue-50 text-blue-700 border border-blue-100 rounded-full px-2.5 py-1">
      {label}
      <button onClick={onRemove} className="hover:text-blue-900 transition-colors" aria-label={`Remove filter: ${label}`}>
        <X className="w-3 h-3" />
      </button>
    </span>
  );
}
