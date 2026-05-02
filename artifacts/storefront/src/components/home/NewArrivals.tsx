import { Link } from 'wouter';
import { ProductCard, type ProductCardDTO } from '@/components/ProductCard';

export function NewArrivals({ products }: { products: ProductCardDTO[] }) {
  if (!products.length) return null;
  return (
    <section className="bg-white section-gap">
      <div className="container-nest">
        <div className="flex items-center justify-between mb-5">
          <h2 className="font-heading font-bold text-[#0D0625] text-xl">New Arrivals</h2>
          <Link href="/products?sort=newest" className="text-sm text-[#E14A5C] font-semibold hover:underline">
            View All →
          </Link>
        </div>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {products.map((product) => <ProductCard key={product.id} product={product} />)}
        </div>
      </div>
    </section>
  );
}
