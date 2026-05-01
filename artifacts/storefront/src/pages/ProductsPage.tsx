import { useEffect, useState, useCallback } from 'react';
import { useLocation } from 'wouter';
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

function toProductDTO(p: any): ProductCardDTO {
  return {
    id: p.id, slug: p.slug, sku: p.sku, name: p.name_en,
    brandName: p.brand?.name_en ?? null, categoryName: p.category?.name_en ?? null,
    imageUrl: p.images?.[0]?.url ?? null,
    basePrice: p.base_price, salePrice: p.sale_price,
    rating: p.avg_rating ?? 0, reviewCount: p.review_count ?? 0,
    inStock: p.available_stock > 0, isFeatured: p.is_featured,
  };
}

const PAGE_SIZE = 24;

export default function ProductsPage() {
  const [location, navigate] = useLocation();
  const filters = parseSearch(window.location.search);

  const [products, setProducts] = useState<ProductCardDTO[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState<Category[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [showFilters, setShowFilters] = useState(false);

  const supabase = getSupabaseClient();

  useEffect(() => {
    Promise.all([
      supabase.from('categories').select('id, name_en, slug, parent_id').eq('is_active', true).is('deleted_at', null).order('sort_order'),
      supabase.from('brands').select('id, name_en, slug').eq('is_active', true).order('name_en'),
    ]).then(([catRes, brandRes]) => {
      setCategories(catRes.data ?? []);
      setBrands(brandRes.data ?? []);
    });
  }, []);

  const loadProducts = useCallback(async () => {
    setLoading(true);
    const { q, category, brand, sort, page, minPrice, maxPrice, inStock } = parseSearch(window.location.search);

    let query = supabase
      .from('products')
      .select(`id, slug, sku, name_en, base_price, sale_price, avg_rating, review_count, available_stock, is_featured, images:product_images(url), brand:brands(name_en, slug), category:categories(name_en, slug)`, { count: 'exact' })
      .eq('is_published', true);

    if (q) query = query.ilike('name_en', `%${q}%`);
    if (category) query = query.eq('categories.slug', category);
    if (brand) query = query.eq('brands.slug', brand);
    if (minPrice) query = query.gte('base_price', parseFloat(minPrice));
    if (maxPrice) query = query.lte('base_price', parseFloat(maxPrice));
    if (inStock) query = query.gt('available_stock', 0);

    if (sort === 'price_asc') query = query.order('base_price', { ascending: true });
    else if (sort === 'price_desc') query = query.order('base_price', { ascending: false });
    else if (sort === 'featured') query = query.eq('is_featured', true).order('created_at', { ascending: false });
    else query = query.order('created_at', { ascending: false });

    const from = (page - 1) * PAGE_SIZE;
    query = query.range(from, from + PAGE_SIZE - 1);

    const { data, count } = await query;
    setProducts((data ?? []).map(toProductDTO));
    setTotal(count ?? 0);
    setLoading(false);
  }, [location]);

  useEffect(() => {
    loadProducts();
  }, [loadProducts]);

  const setFilter = (key: string, value: string) => {
    const params = new URLSearchParams(window.location.search.slice(1));
    if (value) params.set(key, value);
    else params.delete(key);
    params.delete('page');
    navigate(`/products?${params.toString()}`);
  };

  const totalPages = Math.ceil(total / PAGE_SIZE);

  return (
    <div className="container-nest py-6">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h1 className="text-xl font-heading font-semibold text-slate-900">
            {filters.q ? `Search: "${filters.q}"` : 'All Products'}
          </h1>
          <p className="text-xs text-slate-500 mt-0.5">{total} products</p>
        </div>
        <div className="flex items-center gap-2">
          <select
            value={filters.sort}
            onChange={(e) => setFilter('sort', e.target.value)}
            className="text-sm border border-slate-200 rounded-md px-3 py-1.5 bg-white focus:outline-none focus:border-blue-500"
          >
            <option value="newest">Newest</option>
            <option value="featured">Featured</option>
            <option value="price_asc">Price: Low to High</option>
            <option value="price_desc">Price: High to Low</option>
          </select>
          <button
            onClick={() => setShowFilters(!showFilters)}
            className="flex items-center gap-1.5 text-sm border border-slate-200 rounded-md px-3 py-1.5 bg-white hover:bg-slate-50 transition-colors"
          >
            <SlidersHorizontal className="w-4 h-4" />
            Filters
          </button>
        </div>
      </div>

      <div className="flex gap-6">
        {/* Sidebar Filters */}
        <aside className={`${showFilters ? 'block' : 'hidden'} lg:block w-52 shrink-0`}>
          <div className="bg-white border border-slate-200 rounded-lg p-4 space-y-5 sticky top-32">
            <div>
              <h3 className="text-sm font-semibold text-slate-900 mb-2">Category</h3>
              <div className="space-y-1">
                <button
                  onClick={() => setFilter('category', '')}
                  className={`w-full text-left text-sm px-2 py-1 rounded transition-colors ${!filters.category ? 'text-blue-600 font-medium' : 'text-slate-500 hover:text-slate-900'}`}
                >
                  All Categories
                </button>
                {categories.filter(c => !c.parent_id).map((cat) => (
                  <button
                    key={cat.id}
                    onClick={() => setFilter('category', cat.slug)}
                    className={`w-full text-left text-sm px-2 py-1 rounded transition-colors ${filters.category === cat.slug ? 'text-blue-600 font-medium' : 'text-slate-500 hover:text-slate-900'}`}
                  >
                    {cat.name_en}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <h3 className="text-sm font-semibold text-slate-900 mb-2">Brand</h3>
              <div className="space-y-1 max-h-48 overflow-y-auto">
                <button
                  onClick={() => setFilter('brand', '')}
                  className={`w-full text-left text-sm px-2 py-1 rounded transition-colors ${!filters.brand ? 'text-blue-600 font-medium' : 'text-slate-500 hover:text-slate-900'}`}
                >
                  All Brands
                </button>
                {brands.map((brand) => (
                  <button
                    key={brand.id}
                    onClick={() => setFilter('brand', brand.slug)}
                    className={`w-full text-left text-sm px-2 py-1 rounded transition-colors ${filters.brand === brand.slug ? 'text-blue-600 font-medium' : 'text-slate-500 hover:text-slate-900'}`}
                  >
                    {brand.name_en}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <h3 className="text-sm font-semibold text-slate-900 mb-2">Price (EGP)</h3>
              <div className="flex gap-2">
                <input
                  type="number"
                  placeholder="Min"
                  value={filters.minPrice}
                  onChange={(e) => setFilter('minPrice', e.target.value)}
                  className="w-full border border-slate-200 rounded px-2 py-1 text-sm focus:outline-none focus:border-blue-500"
                />
                <input
                  type="number"
                  placeholder="Max"
                  value={filters.maxPrice}
                  onChange={(e) => setFilter('maxPrice', e.target.value)}
                  className="w-full border border-slate-200 rounded px-2 py-1 text-sm focus:outline-none focus:border-blue-500"
                />
              </div>
            </div>

            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="checkbox"
                checked={filters.inStock}
                onChange={(e) => setFilter('inStock', e.target.checked ? 'true' : '')}
                className="rounded border-slate-300"
              />
              <span className="text-sm text-slate-700">In stock only</span>
            </label>
          </div>
        </aside>

        {/* Products Grid */}
        <div className="flex-1">
          {loading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
              {Array.from({ length: 12 }).map((_, i) => <ProductCardSkeleton key={i} />)}
            </div>
          ) : products.length === 0 ? (
            <div className="text-center py-20 border border-slate-200 rounded-lg bg-white">
              <Search className="w-10 h-10 text-slate-300 mx-auto mb-3" />
              <h2 className="text-lg font-semibold text-slate-900 mb-1">No products found</h2>
              <p className="text-slate-500 text-sm">Try adjusting your filters or search terms.</p>
            </div>
          ) : (
            <>
              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
                {products.map((product) => <ProductCard key={product.id} product={product} />)}
              </div>

              {totalPages > 1 && (
                <div className="flex items-center justify-center gap-1 mt-8">
                  {filters.page > 1 && (
                    <button onClick={() => setFilter('page', String(filters.page - 1))} className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100 transition-colors">
                      <ChevronLeft className="w-4 h-4" />
                    </button>
                  )}
                  {Array.from({ length: totalPages }, (_, i) => i + 1)
                    .filter((p) => p === 1 || p === totalPages || Math.abs(p - filters.page) <= 2)
                    .map((p, idx, arr) => (
                      <>
                        {idx > 0 && arr[idx - 1] !== p - 1 && <span key={`ellipsis-${p}`} className="text-slate-400 text-sm px-1">…</span>}
                        <button
                          key={p}
                          onClick={() => setFilter('page', String(p))}
                          className={`flex h-8 w-8 items-center justify-center rounded text-xs font-medium transition-colors ${p === filters.page ? 'bg-blue-600 text-white' : 'text-slate-500 hover:bg-slate-100'}`}
                        >
                          {p}
                        </button>
                      </>
                    ))}
                  {filters.page < totalPages && (
                    <button onClick={() => setFilter('page', String(filters.page + 1))} className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100 transition-colors">
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
