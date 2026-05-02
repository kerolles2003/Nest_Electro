import { useEffect, useState } from 'react';
import { useParams, Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { ProductCard, ProductCardSkeleton, type ProductCardDTO } from '@/components/ProductCard';
import { ChevronRight } from 'lucide-react';

interface Category { id: string; name_en: string; slug: string; parent_id: string | null; }

const PRODUCT_SELECT = `id, slug, sku, name_en, base_price, sale_price, stock_quantity, reserved_quantity, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en, slug)`;

function toProductDTO(p: any): ProductCardDTO {
  const available = (p.stock_quantity ?? 0) - (p.reserved_quantity ?? 0);
  return {
    id: p.id, slug: p.slug, sku: p.sku, name: p.name_en,
    brandName: p.brand?.name_en ?? null, categoryName: p.category?.name_en ?? null,
    imageUrl: p.images?.[0]?.url ?? null,
    basePrice: p.base_price, salePrice: p.sale_price,
    rating: p.avg_rating ?? 0, reviewCount: p.review_count ?? 0,
    inStock: available > 0, isFeatured: p.is_featured,
  };
}

export default function CategoryPage() {
  const { slug } = useParams<{ slug: string }>();
  const [category, setCategory] = useState<Category | null>(null);
  const [subcategories, setSubcategories] = useState<Category[]>([]);
  const [products, setProducts] = useState<ProductCardDTO[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);

  const supabase = getSupabaseClient();

  useEffect(() => {
    if (!slug) return;
    setLoading(true);
    const load = async () => {
      const [catRes, allCatRes] = await Promise.all([
        supabase.from('categories').select('id, name_en, slug, parent_id').eq('slug', slug).single(),
        supabase.from('categories').select('id, name_en, slug, parent_id').eq('is_active', true).is('deleted_at', null),
      ]);
      const cat = catRes.data as Category | null;
      setCategory(cat);
      if (cat) {
        const subs = (allCatRes.data ?? []).filter((c: Category) => c.parent_id === cat.id);
        setSubcategories(subs);
        const prodRes = await supabase
          .from('products')
          .select(PRODUCT_SELECT, { count: 'exact' })
          .eq('is_active', true)
          .is('deleted_at', null)
          .eq('category_id', cat.id)
          .order('created_at', { ascending: false })
          .limit(24);
        setProducts((prodRes.data ?? []).map(toProductDTO));
        setTotal(prodRes.count ?? 0);
      }
      setLoading(false);
    };
    load();
  }, [slug]);

  if (loading) {
    return (
      <div className="container-nest py-6 animate-pulse">
        <div className="h-4 bg-slate-100 rounded w-48 mb-4" />
        <div className="h-6 bg-slate-100 rounded w-40 mb-6" />
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {Array.from({ length: 10 }).map((_, i) => <ProductCardSkeleton key={i} />)}
        </div>
      </div>
    );
  }

  if (!category) {
    return (
      <div className="container-nest py-16 text-center">
        <h1 className="text-xl font-semibold text-slate-900">Category not found</h1>
        <Link href="/categories" className="mt-4 inline-block text-blue-600 hover:underline text-sm">Browse all categories</Link>
      </div>
    );
  }

  return (
    <div className="container-nest py-6">
      <nav className="flex items-center gap-1.5 text-xs text-slate-500 mb-4">
        <Link href="/" className="hover:text-blue-600 transition-colors">Home</Link>
        <ChevronRight className="w-3 h-3" />
        <Link href="/categories" className="hover:text-blue-600 transition-colors">Categories</Link>
        <ChevronRight className="w-3 h-3" />
        <span className="text-slate-900 font-medium">{category.name_en}</span>
      </nav>

      <div className="mb-4">
        <h1 className="text-xl font-heading font-semibold text-slate-900">{category.name_en}</h1>
        <p className="text-xs text-slate-500 mt-0.5">{total} products</p>
      </div>

      {subcategories.length > 0 && (
        <div className="flex flex-wrap gap-2 mb-4">
          {subcategories.map((sub) => (
            <Link
              key={sub.id}
              href={`/categories/${sub.slug}`}
              className="inline-flex items-center px-3 py-1.5 bg-white border border-slate-200 rounded-full text-xs font-medium text-slate-500 hover:text-blue-600 hover:border-blue-400 transition-colors"
            >
              {sub.name_en}
            </Link>
          ))}
        </div>
      )}

      {products.length === 0 ? (
        <div className="text-center py-20 border border-slate-200 rounded-lg bg-white">
          <h3 className="text-lg font-medium text-slate-900">No products in this category</h3>
          <p className="text-slate-500 mt-1 text-sm">Check back later for new arrivals.</p>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {products.map((product) => <ProductCard key={product.id} product={product} />)}
        </div>
      )}
    </div>
  );
}
