import { useEffect, useState, useCallback } from 'react';
import { useLocation, Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { ProductCard, ProductCardSkeleton, type ProductCardDTO } from '@/components/ProductCard';
import { SearchBar } from '@/components/SearchBar';
import { Search, ChevronRight } from 'lucide-react';

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

export default function SearchPage() {
  const [location, navigate] = useLocation();
  const params = new URLSearchParams(window.location.search.slice(1));
  const query = params.get('q') ?? '';
  const page = parseInt(params.get('page') ?? '1', 10) || 1;

  const [products, setProducts] = useState<ProductCardDTO[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);

  const supabase = getSupabaseClient();

  const loadResults = useCallback(async () => {
    if (!query) return;
    setLoading(true);
    const PAGE_SIZE = 24;
    const from = (page - 1) * PAGE_SIZE;
    const { data, count } = await supabase
      .from('products')
      .select(`id, slug, sku, name_en, base_price, sale_price, avg_rating, review_count, available_stock, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en)`, { count: 'exact' })
      .eq('is_published', true)
      .ilike('name_en', `%${query}%`)
      .range(from, from + PAGE_SIZE - 1);
    setProducts((data ?? []).map(toProductDTO));
    setTotal(count ?? 0);
    setLoading(false);
  }, [query, page]);

  useEffect(() => { loadResults(); }, [loadResults]);

  const totalPages = Math.ceil(total / 24);

  return (
    <div className="container-nest py-6">
      <nav className="flex items-center gap-1.5 text-xs text-slate-500 mb-4">
        <Link href="/"><a className="hover:text-blue-600 transition-colors">Home</a></Link>
        <ChevronRight className="w-3 h-3" />
        <span className="text-slate-900 font-medium">Search{query ? `: ${query}` : ''}</span>
      </nav>

      <h1 className="text-xl font-heading font-semibold text-slate-900 mb-4">
        {query ? 'Search Results' : 'Search Products'}
      </h1>

      <div className="mb-6">
        <SearchBar initialQuery={query} />
      </div>

      {!query ? (
        <div className="text-center py-16 border border-slate-200 rounded-lg bg-white">
          <Search className="w-10 h-10 text-slate-300 mx-auto mb-3" />
          <h2 className="text-lg font-semibold text-slate-900 mb-1">Search for products</h2>
          <p className="text-slate-500 text-sm">Enter a search term to find products across our catalog.</p>
        </div>
      ) : loading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {Array.from({ length: 10 }).map((_, i) => <ProductCardSkeleton key={i} />)}
        </div>
      ) : products.length === 0 ? (
        <div className="text-center py-16 border border-slate-200 rounded-lg bg-white">
          <Search className="w-10 h-10 text-slate-300 mx-auto mb-3" />
          <h2 className="text-lg font-semibold text-slate-900 mb-1">No results for '{query}'</h2>
          <ul className="text-sm text-slate-500 space-y-1 mb-5">
            <li>Check your spelling and try again</li>
            <li>Try more general search terms</li>
          </ul>
          <Link href="/products"><a className="inline-flex items-center gap-2 bg-blue-600 text-white text-sm px-5 py-2 rounded-md hover:bg-blue-700 transition-colors">Browse All Products</a></Link>
        </div>
      ) : (
        <>
          <p className="text-xs text-slate-500 mb-4">{total} results for '{query}'</p>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
            {products.map((product) => <ProductCard key={product.id} product={product} />)}
          </div>
          {totalPages > 1 && (
            <div className="flex items-center justify-center gap-1 mt-8">
              {page > 1 && (
                <Link href={`/search?q=${encodeURIComponent(query)}&page=${page - 1}`}>
                  <a className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100">‹</a>
                </Link>
              )}
              {Array.from({ length: totalPages }, (_, i) => i + 1).slice(Math.max(0, page - 3), Math.min(totalPages, page + 2)).map(p => (
                <Link key={p} href={`/search?q=${encodeURIComponent(query)}&page=${p}`}>
                  <a className={`flex h-8 w-8 items-center justify-center rounded text-xs font-medium ${p === page ? 'bg-blue-600 text-white' : 'text-slate-500 hover:bg-slate-100'}`}>{p}</a>
                </Link>
              ))}
              {page < totalPages && (
                <Link href={`/search?q=${encodeURIComponent(query)}&page=${page + 1}`}>
                  <a className="flex h-8 w-8 items-center justify-center rounded text-slate-500 hover:bg-slate-100">›</a>
                </Link>
              )}
            </div>
          )}
        </>
      )}
    </div>
  );
}
