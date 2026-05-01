import { Link } from 'wouter';
import { ProductCard, ProductCardSkeleton, type ProductCardDTO } from '@/components/ProductCard';

export function FeaturedProducts({ products }: { products: ProductCardDTO[] }) {
  if (!products.length) return null;
  return (
    <section className="container-nest section-gap">
      <div className="flex justify-between items-center mb-5">
        <h2 className="text-xl font-heading font-semibold text-slate-900">Featured Products</h2>
        <Link href="/products?sort=featured" className="text-sm text-blue-600 hover:text-blue-700 font-medium">See All</Link>
      </div>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
        {products.map((product) => <ProductCard key={product.id} product={product} />)}
      </div>
    </section>
  );
}

export function FeaturedProductsSkeleton() {
  return (
    <section className="container-nest section-gap">
      <div className="flex justify-between items-center mb-5">
        <div className="h-6 w-40 bg-slate-100 animate-pulse rounded" />
        <div className="h-4 w-16 bg-slate-100 animate-pulse rounded" />
      </div>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
        {Array.from({ length: 5 }).map((_, i) => <ProductCardSkeleton key={i} />)}
      </div>
    </section>
  );
}
