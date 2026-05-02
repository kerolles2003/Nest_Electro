import { useEffect, useState } from 'react';
import { useParams, Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { ProductCard, ProductCardSkeleton, type ProductCardDTO } from '@/components/ProductCard';
import { ChevronRight } from 'lucide-react';

interface Brand { id: string; name_en: string; slug: string; logo_url?: string | null; description_en?: string | null; }

const PRODUCT_SELECT = `id, slug, sku, name_en, base_price, sale_price, stock_quantity, reserved_quantity, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en)`;

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

export default function BrandPage() {
  const { slug } = useParams<{ slug: string }>();
  const [brand, setBrand] = useState<Brand | null>(null);
  const [products, setProducts] = useState<ProductCardDTO[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const supabase = getSupabaseClient();

  useEffect(() => {
    if (!slug) return;
    setLoading(true);
    const load = async () => {
      const { data: brandData } = await supabase.from('brands').select('id, name_en, slug, logo_url, description_en').eq('slug', slug).single();
      setBrand(brandData as Brand | null);
      if (brandData) {
        const { data, count } = await supabase
          .from('products')
          .select(PRODUCT_SELECT, { count: 'exact' })
          .eq('is_active', true)
          .is('deleted_at', null)
          .eq('brand_id', brandData.id)
          .order('created_at', { ascending: false })
          .limit(24);
        setProducts((data ?? []).map(toProductDTO));
        setTotal(count ?? 0);
      }
      setLoading(false);
    };
    load();
  }, [slug]);

  if (loading) return (
    <div className="container-nest py-6 animate-pulse">
      <div className="h-4 bg-slate-100 rounded w-48 mb-4" />
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
        {Array.from({ length: 10 }).map((_, i) => <ProductCardSkeleton key={i} />)}
      </div>
    </div>
  );

  if (!brand) return (
    <div className="container-nest py-16 text-center">
      <h1 className="text-xl font-semibold text-slate-900">Brand not found</h1>
      <Link href="/products" className="mt-4 inline-block text-blue-600 hover:underline text-sm">Browse all products</Link>
    </div>
  );

  return (
    <div className="container-nest py-6">
      <nav className="flex items-center gap-1.5 text-xs text-slate-500 mb-4">
        <Link href="/" className="hover:text-blue-600 transition-colors">Home</Link>
        <ChevronRight className="w-3 h-3" />
        <Link href="/products" className="hover:text-blue-600 transition-colors">Products</Link>
        <ChevronRight className="w-3 h-3" />
        <span className="text-slate-900 font-medium">{brand.name_en}</span>
      </nav>
      <div className="flex items-center gap-3 mb-4">
        {brand.logo_url && (
          <div className="w-12 h-12 bg-white border border-slate-200 rounded-md flex items-center justify-center overflow-hidden flex-shrink-0">
            <img src={brand.logo_url} alt={brand.name_en} className="max-w-full max-h-full object-contain p-1" />
          </div>
        )}
        <div>
          <h1 className="text-xl font-heading font-semibold text-slate-900">{brand.name_en}</h1>
          <p className="text-xs text-slate-500 mt-0.5">{total} products</p>
        </div>
      </div>
      {products.length === 0 ? (
        <div className="text-center py-20 border border-slate-200 rounded-lg">
          <h3 className="text-lg font-medium text-slate-900">No products found</h3>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {products.map((product) => <ProductCard key={product.id} product={product} />)}
        </div>
      )}
    </div>
  );
}
