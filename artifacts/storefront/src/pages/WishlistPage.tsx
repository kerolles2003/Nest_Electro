import { useEffect, useState } from 'react';
import { Link } from 'wouter';
import { Heart, ArrowRight } from 'lucide-react';
import { useWishlistStore } from '@/stores/wishlist-store';
import { getSupabaseClient } from '@/lib/supabase';
import { ProductCard, type ProductCardDTO } from '@/components/ProductCard';
import { ROUTES } from '@/lib/constants';

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

export default function WishlistPage() {
  const { items, removeItem } = useWishlistStore();
  const [products, setProducts] = useState<ProductCardDTO[]>([]);
  const [loading, setLoading] = useState(false);
  const supabase = getSupabaseClient();

  useEffect(() => {
    if (items.length === 0) { setProducts([]); return; }
    setLoading(true);
    supabase
      .from('products')
      .select(`id, slug, sku, name_en, base_price, sale_price, avg_rating, review_count, available_stock, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en)`)
      .in('id', items)
      .then(({ data }) => {
        setProducts((data ?? []).map(toProductDTO));
        setLoading(false);
      });
  }, [items]);

  return (
    <div className="container-nest py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900 flex items-center gap-3">
          <Heart className="w-8 h-8 text-red-500" />
          My Wishlist
        </h1>
        <p className="text-slate-500 mt-2">{items.length} {items.length === 1 ? 'item' : 'items'} saved</p>
      </div>

      {items.length === 0 ? (
        <div className="text-center py-16 border border-slate-200 rounded-xl bg-white">
          <Heart className="w-16 h-16 mx-auto text-slate-200 mb-4" />
          <h2 className="text-xl font-semibold text-slate-900 mb-2">Your wishlist is empty</h2>
          <p className="text-slate-500 mb-6">Save your favorite products to keep track of them.</p>
          <Link href={ROUTES.products}>
            <a className="inline-flex items-center gap-2 bg-blue-600 text-white px-5 py-2.5 rounded-md font-medium hover:bg-blue-700 transition-colors">
              Browse Products <ArrowRight className="w-4 h-4" />
            </a>
          </Link>
        </div>
      ) : loading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {Array.from({ length: items.length }).map((_, i) => (
            <div key={i} className="aspect-[3/4] bg-slate-100 animate-pulse rounded-lg" />
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {products.map((product) => <ProductCard key={product.id} product={product} />)}
        </div>
      )}
    </div>
  );
}
