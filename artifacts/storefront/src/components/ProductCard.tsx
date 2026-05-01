import React from 'react';
import { Link } from 'wouter';
import { Heart, ShoppingCart, Star } from 'lucide-react';
import { useCartStore } from '@/stores/cart-store';
import { useWishlistStore } from '@/stores/wishlist-store';
import { useUIStore } from '@/stores/ui-store';
import { cn } from '@/lib/utils';

export interface ProductCardDTO {
  id: string;
  slug: string;
  sku: string;
  name: string;
  brandName: string | null;
  categoryName: string | null;
  imageUrl: string | null;
  basePrice: number;
  salePrice: number | null;
  rating: number;
  reviewCount: number;
  inStock: boolean;
  isFeatured: boolean;
}

interface ProductCardProps {
  product: ProductCardDTO;
  className?: string;
}

export function ProductCard({ product, className }: ProductCardProps) {
  const addItem = useCartStore((s) => s.addItem);
  const openCart = useUIStore((s) => s.openCart);
  const { hasItem, toggleItem } = useWishlistStore();

  const isWishlisted = hasItem(product.id);
  const price = product.salePrice ?? product.basePrice;
  const hasDiscount = product.salePrice !== null && product.salePrice < product.basePrice;
  const discount = hasDiscount
    ? Math.round(((product.basePrice - product.salePrice!) / product.basePrice) * 100)
    : 0;

  const handleAddToCart = (e: React.MouseEvent) => {
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

  const handleWishlist = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    toggleItem(product.id);
  };

  return (
    <Link href={`/products/${product.slug}`}>
      <div
        className={cn(
          'group relative bg-white border border-slate-200 rounded-lg overflow-hidden hover:border-slate-300 hover:shadow-md transition-all duration-200 cursor-pointer',
          className
        )}
      >
        {/* Image */}
        <div className="relative aspect-square bg-slate-50">
          {product.imageUrl ? (
            <img
              src={product.imageUrl}
              alt={product.name}
              className="w-full h-full object-contain p-2"
              loading="lazy"
            />
          ) : (
            <div className="absolute inset-0 flex items-center justify-center text-slate-300 text-xs">
              No Image
            </div>
          )}

          {/* Badges */}
          <div className="absolute top-2 left-2 flex flex-col gap-1">
            {hasDiscount && (
              <span className="badge bg-blue-600 text-white">-{discount}%</span>
            )}
            {product.isFeatured && (
              <span className="badge bg-amber-500 text-white">Featured</span>
            )}
            {!product.inStock && (
              <span className="badge bg-slate-400 text-white">Out of Stock</span>
            )}
          </div>

          {/* Wishlist button */}
          <button
            onClick={handleWishlist}
            className="absolute top-2 right-2 p-1.5 rounded-full bg-white/80 hover:bg-white shadow-sm opacity-0 group-hover:opacity-100 transition-all duration-150"
            aria-label={isWishlisted ? 'Remove from wishlist' : 'Add to wishlist'}
          >
            <Heart
              className={cn('w-3.5 h-3.5 transition-colors', isWishlisted ? 'text-red-500 fill-red-500' : 'text-slate-400')}
            />
          </button>
        </div>

        {/* Info */}
        <div className="p-3">
          {product.brandName && (
            <p className="text-[10px] font-medium text-blue-600 uppercase tracking-wide mb-0.5">
              {product.brandName}
            </p>
          )}
          <h3 className="text-xs font-medium text-slate-800 line-clamp-2 leading-snug mb-2">
            {product.name}
          </h3>

          {/* Rating */}
          {product.reviewCount > 0 && (
            <div className="flex items-center gap-1 mb-2">
              <Star className="w-3 h-3 text-amber-400 fill-amber-400" />
              <span className="text-[10px] text-slate-500">
                {product.rating.toFixed(1)} ({product.reviewCount})
              </span>
            </div>
          )}

          {/* Price */}
          <div className="flex items-baseline gap-1.5 mb-2.5">
            <span className="text-sm font-bold text-blue-600">
              EGP {price.toLocaleString()}
            </span>
            {hasDiscount && (
              <span className="text-xs text-slate-400 line-through">
                EGP {product.basePrice.toLocaleString()}
              </span>
            )}
          </div>

          {/* Add to cart */}
          <button
            onClick={handleAddToCart}
            disabled={!product.inStock}
            className="w-full flex items-center justify-center gap-1.5 py-1.5 text-xs font-medium rounded bg-blue-600 text-white hover:bg-blue-700 disabled:bg-slate-200 disabled:text-slate-400 disabled:cursor-not-allowed transition-colors duration-150"
          >
            <ShoppingCart className="w-3.5 h-3.5" />
            {product.inStock ? 'Add to Cart' : 'Out of Stock'}
          </button>
        </div>
      </div>
    </Link>
  );
}

export function ProductCardSkeleton() {
  return (
    <div className="bg-white border border-slate-200 rounded-lg overflow-hidden animate-pulse">
      <div className="aspect-square bg-slate-100" />
      <div className="p-3 space-y-2">
        <div className="h-3 bg-slate-100 rounded w-1/3" />
        <div className="h-3 bg-slate-100 rounded" />
        <div className="h-3 bg-slate-100 rounded w-2/3" />
        <div className="h-4 bg-slate-100 rounded w-1/2 mt-1" />
        <div className="h-7 bg-slate-100 rounded mt-1" />
      </div>
    </div>
  );
}
