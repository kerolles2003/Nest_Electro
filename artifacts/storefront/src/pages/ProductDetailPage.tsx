import { useEffect, useState } from 'react';
import { useParams, Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { useCartStore } from '@/stores/cart-store';
import { useWishlistStore } from '@/stores/wishlist-store';
import { useUIStore } from '@/stores/ui-store';
import { QuantitySelector } from '@/components/QuantitySelector';
import { ShoppingCart, Heart, Star, ChevronRight, Package, Shield, Truck, RotateCcw } from 'lucide-react';

interface ProductImage { url: string; alt_text?: string; }
interface ProductDetail {
  id: string; slug: string; sku: string; name_en: string;
  description_en?: string; base_price: number; sale_price: number | null;
  stock_quantity: number; reserved_quantity: number;
  is_featured: boolean; is_active: boolean;
  brand?: { name_en: string; slug: string } | null;
  category?: { name_en: string; slug: string } | null;
  images: ProductImage[];
}

export default function ProductDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  const [product, setProduct] = useState<ProductDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [quantity, setQuantity] = useState(1);
  const [selectedImage, setSelectedImage] = useState(0);
  const [avgRating, setAvgRating] = useState(0);
  const [reviewCount, setReviewCount] = useState(0);

  const addItem = useCartStore((s) => s.addItem);
  const openCart = useUIStore((s) => s.openCart);
  const { hasItem, toggleItem } = useWishlistStore();
  const supabase = getSupabaseClient();

  useEffect(() => {
    if (!slug) return;
    setLoading(true);
    setSelectedImage(0);
    setQuantity(1);
    setAvgRating(0);
    setReviewCount(0);

    supabase
      .from('products')
      .select(`id, slug, sku, name_en, description_en, base_price, sale_price, stock_quantity, reserved_quantity, is_featured, is_active, images:product_images(url, alt_text), brand:brands(name_en, slug), category:categories(name_en, slug)`)
      .eq('slug', slug)
      .eq('is_active', true)
      .is('deleted_at', null)
      .single()
      .then(({ data }: { data: ProductDetail | null }) => {
        setProduct(data);
        setLoading(false);
        if (data) {
          supabase
            .from('reviews')
            .select('rating', { count: 'exact' })
            .eq('product_id', data.id)
            .eq('moderation_status', 'approved')
            .then(({ data: reviews, count }: { data: { rating: number | null }[] | null; count: number | null }) => {
              const cnt = count ?? 0;
              if (cnt > 0 && reviews) {
                const sum = reviews.reduce((acc, r) => acc + (r.rating ?? 0), 0);
                setAvgRating(Math.round((sum / cnt) * 10) / 10);
                setReviewCount(cnt);
              }
            });
        }
      });
  }, [slug]);

  if (loading) {
    return (
      <div className="container-nest py-6 animate-pulse">
        <div className="h-4 bg-[#f2f2f2] rounded w-48 mb-6" />
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="aspect-square bg-[#f2f2f2] rounded-lg" />
          <div className="space-y-4">
            <div className="h-6 bg-[#f2f2f2] rounded w-3/4" />
            <div className="h-4 bg-[#f2f2f2] rounded w-1/2" />
            <div className="h-8 bg-[#f2f2f2] rounded w-1/3" />
            <div className="h-10 bg-[#f2f2f2] rounded w-full" />
          </div>
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="container-nest py-16 text-center">
        <Package className="w-12 h-12 mx-auto text-[#ddd] mb-4" />
        <h1 className="text-xl font-heading font-semibold text-[#0D0625]">Product not found</h1>
        <p className="text-[#777] mt-2 text-sm">This product may have been removed or doesn't exist.</p>
        <Link href="/products" className="mt-4 inline-block text-[#E14A5C] hover:underline text-sm font-medium">
          Browse all products
        </Link>
      </div>
    );
  }

  const availableStock = (product.stock_quantity ?? 0) - (product.reserved_quantity ?? 0);
  const price = product.sale_price ?? product.base_price;
  const hasDiscount = product.sale_price !== null && product.sale_price < product.base_price;
  const discount = hasDiscount ? Math.round(((product.base_price - product.sale_price!) / product.base_price) * 100) : 0;
  const inStock = availableStock > 0;
  const isWishlisted = hasItem(product.id);

  const handleAddToCart = () => {
    if (!inStock) return;
    addItem({
      id: product.id, name_en: product.name_en, slug: product.slug, sku: product.sku,
      base_price: product.base_price, sale_price: product.sale_price,
      images: product.images.map((img) => ({ url: img.url })),
      available_stock: availableStock,
    }, quantity);
    openCart();
  };

  return (
    <div className="bg-[#f8f8f8] min-h-screen">
      <div className="container-nest py-6">
        {/* Breadcrumb */}
        <nav className="flex items-center gap-1.5 text-xs text-[#999] mb-5">
          <Link href="/" className="hover:text-[#E14A5C] transition-colors">Home</Link>
          <ChevronRight className="w-3 h-3" />
          {product.category && (
            <>
              <Link href={`/categories/${product.category.slug}`} className="hover:text-[#E14A5C] transition-colors">
                {product.category.name_en}
              </Link>
              <ChevronRight className="w-3 h-3" />
            </>
          )}
          <span className="text-[#0D0625] font-medium truncate max-w-[200px]">{product.name_en}</span>
        </nav>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 lg:gap-10">
          {/* Images */}
          <div className="space-y-3">
            <div className="aspect-square bg-white border border-[#e8e8e8] rounded-lg overflow-hidden flex items-center justify-center">
              {product.images[selectedImage]?.url ? (
                <img
                  src={product.images[selectedImage].url}
                  alt={product.name_en}
                  className="w-full h-full object-contain p-6"
                />
              ) : (
                <div className="text-[#ccc] text-sm">No image available</div>
              )}
            </div>
            {product.images.length > 1 && (
              <div className="flex gap-2 overflow-x-auto scrollbar-none">
                {product.images.map((img, i) => (
                  <button
                    key={i}
                    onClick={() => setSelectedImage(i)}
                    className={`flex-shrink-0 w-16 h-16 border rounded-md overflow-hidden transition-colors bg-white ${i === selectedImage ? 'border-[#E14A5C]' : 'border-[#e8e8e8] hover:border-[#E14A5C]/50'}`}
                  >
                    <img src={img.url} alt={product.name_en} className="w-full h-full object-contain p-1" />
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Info */}
          <div className="bg-white border border-[#e8e8e8] rounded-lg p-6 space-y-4">
            {product.brand && (
              <Link href={`/brands/${product.brand.slug}`} className="text-xs font-bold text-[#E14A5C] uppercase tracking-widest hover:underline">
                {product.brand.name_en}
              </Link>
            )}

            <h1 className="font-heading font-bold text-xl text-[#0D0625] leading-snug">{product.name_en}</h1>

            {/* Stars */}
            {reviewCount > 0 && (
              <div className="flex items-center gap-2">
                <div className="flex">
                  {Array.from({ length: 5 }).map((_, i) => (
                    <Star key={i} className={`w-4 h-4 ${i < Math.round(avgRating) ? 'text-amber-400 fill-amber-400' : 'text-[#e0e0e0] fill-[#e0e0e0]'}`} />
                  ))}
                </div>
                <span className="text-sm text-[#777]">{avgRating.toFixed(1)} ({reviewCount} review{reviewCount !== 1 ? 's' : ''})</span>
              </div>
            )}

            {/* Price */}
            <div className="flex items-baseline gap-3 py-2 border-y border-[#f0f0f0]">
              <span className="text-3xl font-bold text-[#E14A5C]">EGP {price.toLocaleString()}</span>
              {hasDiscount && (
                <>
                  <span className="text-lg text-[#bbb] line-through">EGP {product.base_price.toLocaleString()}</span>
                  <span className="text-xs font-bold text-white bg-[#E14A5C] px-2 py-0.5 rounded">-{discount}% OFF</span>
                </>
              )}
            </div>

            {/* Stock status */}
            <div className="flex items-center gap-3">
              <span className={`inline-flex items-center gap-1.5 text-xs font-semibold px-2.5 py-1 rounded-full ${inStock ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-600'}`}>
                <span className={`w-1.5 h-1.5 rounded-full ${inStock ? 'bg-green-500' : 'bg-red-500'}`} />
                {inStock ? `In Stock (${availableStock} available)` : 'Out of Stock'}
              </span>
              <span className="text-xs text-[#aaa]">SKU: {product.sku}</span>
            </div>

            {/* Qty + Add to cart */}
            {inStock ? (
              <div className="space-y-3 pt-1">
                <div className="flex items-center gap-3">
                  <span className="text-sm font-medium text-[#444]">Quantity:</span>
                  <QuantitySelector
                    quantity={quantity}
                    onIncrease={() => setQuantity((q) => Math.min(q + 1, availableStock))}
                    onDecrease={() => setQuantity((q) => Math.max(q - 1, 1))}
                    max={availableStock}
                  />
                </div>
                <div className="flex gap-3">
                  <button
                    onClick={handleAddToCart}
                    className="flex-1 flex items-center justify-center gap-2 py-3 bg-[#E14A5C] hover:bg-[#c93e4e] text-white rounded-md font-semibold transition-colors active:scale-[0.98]"
                  >
                    <ShoppingCart className="w-5 h-5" />
                    Add to Cart
                  </button>
                  <button
                    onClick={() => toggleItem(product.id)}
                    className={`p-3 rounded-md border transition-colors ${isWishlisted ? 'border-[#E14A5C]/30 bg-[#fde8ea] text-[#E14A5C]' : 'border-[#e8e8e8] text-[#aaa] hover:border-[#E14A5C]/30 hover:bg-[#fde8ea] hover:text-[#E14A5C]'}`}
                    aria-label={isWishlisted ? 'Remove from wishlist' : 'Add to wishlist'}
                  >
                    <Heart className={`w-5 h-5 ${isWishlisted ? 'fill-[#E14A5C]' : ''}`} />
                  </button>
                </div>
              </div>
            ) : (
              <button
                onClick={() => toggleItem(product.id)}
                className="flex items-center justify-center gap-2 py-3 w-full border border-[#e8e8e8] text-[#555] rounded-md font-medium hover:bg-[#fde8ea] hover:text-[#E14A5C] hover:border-[#E14A5C]/30 transition-colors"
              >
                <Heart className={`w-5 h-5 ${isWishlisted ? 'text-[#E14A5C] fill-[#E14A5C]' : ''}`} />
                {isWishlisted ? 'Saved to Wishlist' : 'Save to Wishlist'}
              </button>
            )}

            {/* Trust signals */}
            <div className="border-t border-[#f0f0f0] pt-4 grid grid-cols-3 gap-3">
              {[
                { icon: Truck,      text: 'Fast Delivery' },
                { icon: Shield,     text: 'Genuine Parts' },
                { icon: RotateCcw, text: 'Easy Returns' },
              ].map(({ icon: Icon, text }) => (
                <div key={text} className="flex flex-col items-center gap-1.5 text-center">
                  <div className="w-8 h-8 rounded-full bg-[#fde8ea] flex items-center justify-center">
                    <Icon className="w-4 h-4 text-[#E14A5C]" strokeWidth={1.5} />
                  </div>
                  <span className="text-xs text-[#777]">{text}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Description */}
        {product.description_en && (
          <div className="mt-8 bg-white border border-[#e8e8e8] rounded-lg p-6">
            <h2 className="font-heading font-bold text-lg text-[#0D0625] mb-4">Product Description</h2>
            <div className="text-sm text-[#555] leading-relaxed whitespace-pre-line">
              {product.description_en}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
