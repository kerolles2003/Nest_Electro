import { useEffect, useState } from 'react';
import { Link } from 'wouter';
import { Heart } from 'lucide-react';
import { useWishlistStore } from '@/stores/wishlist-store';
import { getSupabaseClient } from '@/lib/supabase';
import { ProductCard, type ProductCardDTO } from '@/components/ProductCard';
import { ROUTES } from '@/lib/constants';

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
      .select(PRODUCT_SELECT)
      .in('id', items)
      .then(({ data }: { data: Record<string, unknown>[] | null }) => {
        setProducts((data ?? []).map(toProductDTO));
        setLoading(false);
      });
  }, [items]);

  return (
    <div className="bg-[#f8f8f8] min-h-screen">
      <div className="container-nest py-8">
        {/* Page header */}
        <div className="mb-6">
          <div className="flex items-center gap-2 text-xs text-[#999] mb-3">
            <Link href="/" className="hover:text-[#E14A5C] transition-colors">Home</Link>
            <span>/</span>
            <span className="text-[#0D0625] font-medium">Wishlist</span>
          </div>
          <h1 className="font-heading font-bold text-2xl text-[#0D0625] flex items-center gap-2">
            <Heart className="w-6 h-6 text-[#E14A5C]" />
            My Wishlist
            {items.length > 0 && (
              <span className="text-sm font-normal text-[#999] ml-1">({items.length} item{items.length !== 1 ? 's' : ''})</span>
            )}
          </h1>
        </div>

        {items.length === 0 ? (
          <div className="text-center py-20 bg-white border border-[#e8e8e8] rounded-lg">
            <div className="w-20 h-20 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
              <Heart className="w-10 h-10 text-[#E14A5C]/40" />
            </div>
            <h2 className="font-heading font-bold text-xl text-[#0D0625] mb-2">Your wishlist is empty</h2>
            <p className="text-[#777] text-sm mb-6">Save items you love by clicking the heart icon on any product.</p>
            <Link
              href={ROUTES.products}
              className="inline-flex items-center gap-2 bg-[#E14A5C] hover:bg-[#c93e4e] text-white px-6 py-2.5 rounded-md font-semibold text-sm transition-colors"
            >
              Browse Products
            </Link>
          </div>
        ) : loading ? (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3 animate-pulse">
            {Array.from({ length: items.length }).map((_, i) => (
              <div key={i} className="bg-white border border-[#e8e8e8] rounded-lg overflow-hidden">
                <div className="aspect-square bg-[#f2f2f2]" />
                <div className="p-3 space-y-2">
                  <div className="h-3 bg-[#f2f2f2] rounded" />
                  <div className="h-4 bg-[#f2f2f2] rounded w-1/2" />
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
            {products.map((product) => (
              <div key={product.id} className="relative">
                <ProductCard product={product} />
                <button
                  onClick={() => removeItem(product.id)}
                  className="absolute top-2 left-2 text-[10px] bg-white border border-[#e8e8e8] px-1.5 py-0.5 rounded text-[#777] hover:text-[#E14A5C] hover:border-[#E14A5C]/30 transition-colors z-10"
                >
                  Remove
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
