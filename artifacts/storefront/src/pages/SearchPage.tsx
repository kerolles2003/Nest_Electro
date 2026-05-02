import { useEffect, useState, useCallback } from 'react';
import { useLocation, useSearch, Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { ProductCard, ProductCardSkeleton, type ProductCardDTO } from '@/components/ProductCard';
import { SearchBar } from '@/components/SearchBar';
import { Search, ChevronRight, ChevronLeft } from 'lucide-react';

const PAGE_SIZE = 24;

// avg_rating and review_count are not columns in the products table;
// they are aggregated from the reviews table separately when needed.
const PRODUCT_SELECT = `id, slug, sku, name_en, base_price, sale_price, stock_quantity, reserved_quantity, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en)`;

function toProductDTO(p: any): ProductCardDTO {
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

export default function SearchPage() {
  const [, navigate] = useLocation();
  const search = useSearch();
  const params = new URLSearchParams(search.startsWith('?') ? search.slice(1) : search);
  const query = params.get('q') ?? '';
  const page = parseInt(params.get('page') ?? '1', 10) || 1;

  const [products, setProducts] = useState<ProductCardDTO[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);

  const supabase = getSupabaseClient();

  const loadResults = useCallback(async () => {
    if (!query) { setProducts([]); setTotal(0); return; }
    setLoading(true);
    const from = (page - 1) * PAGE_SIZE;
    const { data, count } = await supabase
      .from('products')
      .select(PRODUCT_SELECT, { count: 'exact' })
      .eq('is_active', true)
      .is('deleted_at', null)
      .ilike('name_en', `%${query}%`)
      .order('created_at', { ascending: false })
      .range(from, from + PAGE_SIZE - 1);
    setProducts((data ?? []).map(toProductDTO));
    setTotal(count ?? 0);
    setLoading(false);
  }, [search]);

  useEffect(() => { loadResults(); }, [loadResults]);

  const setPageParam = (p: number) => {
    const ps = new URLSearchParams(search.startsWith('?') ? search.slice(1) : search);
    ps.set('page', String(p));
    navigate(`/search?${ps.toString()}`);
  };

  const totalPages = Math.ceil(total / PAGE_SIZE);

  return (
    <div className="container-nest py-6">
      <nav className="flex items-center gap-1.5 text-xs text-slate-500 mb-4">
        <Link href="/" className="hover:text-blue-600 transition-colors">Home</Link>
        <ChevronRight className="w-3 h-3" />
        <span className="text-slate-900 font-medium">Search</span>
      </nav>

      <div className="mb-6 max-w-xl">
        <SearchBar />
      </div>

      {!query ? (
        <div className="text-center py-20">
          <Search className="w-12 h-12 text-slate-200 mx-auto mb-3" />
          <p className="text-slate-500">Enter a search term to find products</p>
        </div>
      ) : loading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {Array.from({ length: 10 }).map((_, i) => <ProductCardSkeleton key={i} />)}
        </div>
      ) : products.length === 0 ? (
        <div className="text-center py-20">
          <Search className="w-12 h-12 text-slate-200 mx-auto mb-3" />
          <h2 className="text-lg font-semibold text-slate-900 mb-1">No results for "{query}"</h2>
          <p className="text-slate-500 text-sm mb-4">Try different keywords or browse all products.</p>
          <Link href="/products" className="inline-flex items-center gap-2 bg-blue-600 text-white text-sm px-5 py-2 rounded-md hover:bg-blue-700 transition-colors">Browse All Products</Link>
        </div>
      ) : (
        <>
          <p className="text-sm text-slate-500 mb-4">{total} results for "{query}"</p>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
            {products.map((product) => <ProductCard key={product.id} product={product} />)}
          </div>

          {totalPages > 1 && (
            <div className="flex items-center justify-center gap-1 mt-8">
              {page > 1 && (
                <button onClick={() => setPageParam(page - 1)} className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100 transition-colors">
                  <ChevronLeft className="w-4 h-4" />
                </button>
              )}
              {Array.from({ length: totalPages }, (_, i) => i + 1)
                .filter((p) => p === 1 || p === totalPages || Math.abs(p - page) <= 2)
                .map((p, idx, arr) => (
                  <span key={p} className="contents">
                    {idx > 0 && arr[idx - 1] !== p - 1 && <span className="text-slate-400 text-sm px-1">…</span>}
                    <button
                      onClick={() => setPageParam(p)}
                      className={`flex h-8 w-8 items-center justify-center rounded text-xs font-medium transition-colors ${p === page ? 'bg-blue-600 text-white' : 'text-slate-500 hover:bg-slate-100'}`}
                    >
                      {p}
                    </button>
                  </span>
                ))}
              {page < totalPages && (
                <button onClick={() => setPageParam(page + 1)} className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100 transition-colors">
                  <ChevronRight className="w-4 h-4" />
                </button>
              )}
            </div>
          )}
        </>
      )}
    </div>
  );
}
