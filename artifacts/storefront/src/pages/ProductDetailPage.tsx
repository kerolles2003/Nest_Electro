import { useEffect, useState } from 'react';
import { useParams, Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { useCartStore } from '@/stores/cart-store';
import { useWishlistStore } from '@/stores/wishlist-store';
import { useUIStore } from '@/stores/ui-store';
import { QuantitySelector } from '@/components/QuantitySelector';
import { ShoppingCart, Heart, Star, ChevronRight, Package, Shield, Truck } from 'lucide-react';

interface ProductImage { url: string; alt_text?: string; }
interface ProductDetail {
  id: string; slug: string; sku: string; name_en: string;
  description_en?: string; base_price: number; sale_price: number | null;
  stock_quantity: number; reserved_quantity: number;
  is_featured: boolean; is_active: boolean;
  brand?: { name_en: string; slug: string } | null;
  category?: { name_en: string; slug: string } | null;
  images: ProductImage[];
  specifications?: Record<string, string> | null;
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
      .then(({ data }) => {
        setProduct(data as any);
        setLoading(false);
        if (data) {
          supabase
            .from('reviews')
            .select('rating', { count: 'exact' })
            .eq('product_id', (data as any).id)
            .eq('moderation_status', 'approved')
            .then(({ data: reviews, count }) => {
              const cnt = count ?? 0;
              if (cnt > 0 && reviews) {
                const sum = reviews.reduce((acc: number, r: any) => acc + (r.rating ?? 0), 0);
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
        <div className="h-4 bg-slate-100 rounded w-48 mb-6" />
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="aspect-square bg-slate-100 rounded-lg" />
          <div className="space-y-4">
            <div className="h-6 bg-slate-100 rounded w-3/4" />
            <div className="h-4 bg-slate-100 rounded w-1/2" />
            <div className="h-8 bg-slate-100 rounded w-1/3" />
            <div className="h-10 bg-slate-100 rounded w-full" />
          </div>
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="container-nest py-16 text-center">
        <Package className="w-12 h-12 mx-auto text-slate-300 mb-4" />
        <h1 className="text-xl font-semibold text-slate-900">Product not found</h1>
        <p className="text-slate-500 mt-2">This product may have been removed or doesn't exist.</p>
        <Link href="/products" className="mt-4 inline-block text-blue-600 hover:underline text-sm">Browse all products</Link>
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
    <div className="container-nest py-6">
      {/* Breadcrumb */}
      <nav className="flex items-center gap-1.5 text-xs text-slate-500 mb-6">
        <Link href="/" className="hover:text-blue-600 transition-colors">Home</Link>
        <ChevronRight className="w-3 h-3" />
        {product.category && (
          <>
            <Link href={`/categories/${product.category.slug}`} className="hover:text-blue-600 transition-colors">{product.category.name_en}</Link>
            <ChevronRight className="w-3 h-3" />
          </>
        )}
        <span className="text-slate-900 font-medium">{product.name_en}</span>
      </nav>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8 lg:gap-12">
        {/* Images */}
        <div className="space-y-3">
          <div className="aspect-square bg-white border border-slate-200 rounded-lg overflow-hidden flex items-center justify-center">
            {product.images[selectedImage]?.url ? (
              <img
                src={product.images[selectedImage].url}
                alt={product.name_en}
                className="w-full h-full object-contain p-4"
              />
            ) : (
              <div className="text-slate-300 text-sm">No image available</div>
            )}
          </div>
          {product.images.length > 1 && (
            <div className="flex gap-2 overflow-x-auto scrollbar-none">
              {product.images.map((img, i) => (
                <button
                  key={i}
                  onClick={() => setSelectedImage(i)}
                  className={`flex-shrink-0 w-16 h-16 border rounded-md overflow-hidden transition-colors ${i === selectedImage ? 'border-blue-500' : 'border-slate-200 hover:border-slate-300'}`}
                >
                  <img src={img.url} alt={product.name_en} className="w-full h-full object-contain p-1" />
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Info */}
        <div className="space-y-4">
          {product.brand && (
            <Link href={`/brands/${product.brand.slug}`} className="text-xs font-semibold text-blue-600 uppercase tracking-wide hover:underline">{product.brand.name_en}</Link>
          )}
          <h1 className="text-2xl font-heading font-bold text-slate-900">{product.name_en}</h1>

          {reviewCount > 0 && (
            <div className="flex items-center gap-2">
              <div className="flex">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Star key={i} className={`w-4 h-4 ${i < Math.round(avgRating) ? 'text-amber-400 fill-amber-400' : 'text-slate-200'}`} />
                ))}
              </div>
              <span className="text-sm text-slate-500">({reviewCount} reviews)</span>
            </div>
          )}

          <div className="flex items-baseline gap-3">
            <span className="text-3xl font-bold text-blue-600">EGP {price.toLocaleString()}</span>
            {hasDiscount && (
              <>
                <span className="text-lg text-slate-400 line-through">EGP {product.base_price.toLocaleString()}</span>
                <span className="text-sm font-semibold text-green-600 bg-green-50 px-2 py-0.5 rounded">-{discount}% OFF</span>
              </>
            )}
          </div>

          <div className="flex items-center gap-2">
            <span className={`inline-flex items-center gap-1 text-xs font-medium px-2 py-1 rounded ${inStock ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-600'}`}>
              <span className={`w-1.5 h-1.5 rounded-full ${inStock ? 'bg-green-500' : 'bg-red-500'}`} />
              {inStock ? `In Stock (${availableStock} available)` : 'Out of Stock'}
            </span>
            <span className="text-xs text-slate-400">SKU: {product.sku}</span>
          </div>

          {inStock && (
            <div className="space-y-3 pt-2">
              <div className="flex items-center gap-3">
                <span className="text-sm font-medium text-slate-700">Quantity:</span>
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
                  className="flex-1 flex items-center justify-center gap-2 py-3 bg-blue-600 text-white rounded-md font-semibold hover:bg-blue-700 transition-colors active:scale-[0.98]"
                >
                  <ShoppingCart className="w-5 h-5" />
                  Add to Cart
                </button>
                <button
                  onClick={() => toggleItem(product.id)}
                  className={`p-3 rounded-md border transition-colors ${isWishlisted ? 'border-red-200 bg-red-50 text-red-500' : 'border-slate-200 text-slate-500 hover:border-slate-300 hover:bg-slate-50'}`}
                  aria-label={isWishlisted ? 'Remove from wishlist' : 'Add to wishlist'}
                >
                  <Heart className={`w-5 h-5 ${isWishlisted ? 'fill-red-500' : ''}`} />
                </button>
              </div>
            </div>
          )}

          {!inStock && (
            <button
              onClick={() => toggleItem(product.id)}
              className="flex items-center justify-center gap-2 py-3 w-full border border-slate-200 text-slate-700 rounded-md font-medium hover:bg-slate-50 transition-colors"
            >
              <Heart className={`w-5 h-5 ${isWishlisted ? 'text-red-500 fill-red-500' : ''}`} />
              {isWishlisted ? 'Saved to Wishlist' : 'Save to Wishlist'}
            </button>
          )}

          {/* Trust signals */}
          <div className="border-t border-slate-100 pt-4 grid grid-cols-3 gap-3">
            {[
              { icon: Truck, text: 'Fast Delivery' },
              { icon: Shield, text: 'Genuine Parts' },
              { icon: Package, text: 'Easy Returns' },
            ].map(({ icon: Icon, text }) => (
              <div key={text} className="flex flex-col items-center gap-1 text-center">
                <Icon className="w-4 h-4 text-blue-600" strokeWidth={1.5} />
                <span className="text-xs text-slate-500">{text}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Description */}
      {product.description_en && (
        <div className="mt-10 border-t border-slate-200 pt-8">
          <h2 className="text-lg font-semibold text-slate-900 mb-4">Product Description</h2>
          <div className="prose prose-sm max-w-none text-slate-600 leading-relaxed whitespace-pre-line">
            {product.description_en}
          </div>
        </div>
      )}

      {/* Specifications — rendered if the product has specifications data */}
      {product.specifications && Object.keys(product.specifications).length > 0 && (
        <div className="mt-8 border-t border-slate-200 pt-8">
          <h2 className="text-lg font-semibold text-slate-900 mb-4">Specifications</h2>
          <table className="w-full text-sm border-collapse">
            <tbody>
              {Object.entries(product.specifications).map(([key, value]) => (
                <tr key={key} className="border-b border-slate-100">
                  <td className="py-2.5 pr-6 font-medium text-slate-600 w-40">{key}</td>
                  <td className="py-2.5 text-slate-900">{value}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
