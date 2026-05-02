import { Link } from 'wouter';
import { Star, ShoppingCart } from 'lucide-react';
import { useCartStore } from '@/stores/cart-store';
import { useUIStore } from '@/stores/ui-store';
import type { ProductCardDTO } from '@/components/ProductCard';

interface BestPickProps {
  products: ProductCardDTO[];
}

export function BestPick({ products }: BestPickProps) {
  const addItem = useCartStore((s) => s.addItem);
  const openCart = useUIStore((s) => s.openCart);

  if (!products.length) return null;

  const handleAddToCart = (e: React.MouseEvent, product: ProductCardDTO) => {
    e.preventDefault();
    e.stopPropagation();
    if (!product.inStock) return;
    addItem({
      id: product.id,
      name_en: product.name,
      slug: product.slug,
      sku: product.sku,
      base_price: product.basePrice,
      sale_price: product.salePrice,
      images: product.imageUrl ? [{ url: product.imageUrl }] : [],
      available_stock: product.inStock ? 999 : 0,
    });
    openCart();
  };

  return (
    <section className="bg-[#f8f8f8] border-y border-[#ebebeb]">
      <div className="container-nest py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-5">
          <div className="flex items-center gap-3">
            <span className="inline-flex items-center gap-1.5 bg-[#E14A5C] text-white text-[11px] font-bold uppercase tracking-widest px-3 py-1 rounded-full">
              <Star className="w-3 h-3 fill-white" />
              Best Pick
            </span>
            <h2 className="font-heading font-bold text-[#0D0625] text-xl">of the Week</h2>
          </div>
          <Link href="/products?sort=rating" className="text-sm text-[#E14A5C] font-semibold hover:underline">
            View All →
          </Link>
        </div>

        {/* Horizontal scroll strip */}
        <div className="flex gap-4 overflow-x-auto scrollbar-thin pb-2 -mx-1 px-1">
          {products.map((product) => {
            const price = product.salePrice ?? product.basePrice;
            const hasDiscount = product.salePrice !== null && product.salePrice < product.basePrice;
            const discount = hasDiscount
              ? Math.round(((product.basePrice - product.salePrice!) / product.basePrice) * 100)
              : 0;
            const rating = product.rating ?? 0;

            return (
              <Link key={product.id} href={`/products/${product.slug}`} className="group flex-shrink-0 w-[200px]">
                <div className="bg-white border border-[#e8e8e8] rounded-lg overflow-hidden hover:border-[#E14A5C] hover:shadow-md transition-all duration-200">
                  {/* Image */}
                  <div className="relative aspect-square bg-[#f8f8f8]">
                    {product.imageUrl ? (
                      <img
                        src={product.imageUrl}
                        alt={product.name}
                        className="w-full h-full object-contain p-3"
                        loading="lazy"
                      />
                    ) : (
                      <div className="absolute inset-0 flex items-center justify-center text-[#ccc] text-xs">No Image</div>
                    )}
                    {hasDiscount && (
                      <span className="absolute top-2 left-2 bg-[#E14A5C] text-white text-[10px] font-bold px-1.5 py-0.5 rounded">
                        -{discount}%
                      </span>
                    )}
                  </div>

                  {/* Info */}
                  <div className="p-3">
                    {product.brandName && (
                      <p className="text-[10px] font-semibold text-[#E14A5C] uppercase tracking-wide mb-0.5">{product.brandName}</p>
                    )}
                    <h3 className="text-xs font-medium text-[#0D0625] line-clamp-2 leading-snug mb-2">{product.name}</h3>

                    {/* Stars */}
                    <div className="flex items-center gap-0.5 mb-2">
                      {[1, 2, 3, 4, 5].map((star) => (
                        <Star
                          key={star}
                          className={`w-3 h-3 ${star <= Math.round(rating) ? 'text-amber-400 fill-amber-400' : 'text-[#ddd] fill-[#ddd]'}`}
                        />
                      ))}
                      {product.reviewCount > 0 && (
                        <span className="text-[10px] text-[#999] ml-1">({product.reviewCount})</span>
                      )}
                    </div>

                    {/* Price */}
                    <div className="flex items-baseline gap-1.5 mb-2.5">
                      <span className="text-sm font-bold text-[#E14A5C]">EGP {price.toLocaleString()}</span>
                      {hasDiscount && (
                        <span className="text-[11px] text-[#999] line-through">EGP {product.basePrice.toLocaleString()}</span>
                      )}
                    </div>

                    {/* Add to cart */}
                    <button
                      onClick={(e) => handleAddToCart(e, product)}
                      disabled={!product.inStock}
                      className="w-full flex items-center justify-center gap-1.5 py-1.5 text-[11px] font-semibold rounded border border-[#E14A5C] text-[#E14A5C] hover:bg-[#E14A5C] hover:text-white disabled:border-[#ddd] disabled:text-[#aaa] disabled:cursor-not-allowed transition-all duration-150"
                    >
                      <ShoppingCart className="w-3.5 h-3.5" />
                      {product.inStock ? 'Add to Cart' : 'Out of Stock'}
                    </button>
                  </div>
                </div>
              </Link>
            );
          })}
        </div>
      </div>
    </section>
  );
}
