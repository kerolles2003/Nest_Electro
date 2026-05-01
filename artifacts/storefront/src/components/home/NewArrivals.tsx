import { Link } from 'wouter';
import { ProductCard, type ProductCardDTO } from '@/components/ProductCard';

export function NewArrivals({ products }: { products: ProductCardDTO[] }) {
  if (!products.length) return null;
  return (
    <section className="container-nest section-gap">
      <div className="flex justify-between items-center mb-5">
        <h2 className="text-xl font-heading font-semibold text-slate-900">New Arrivals</h2>
        <Link href="/products?sort=newest"><a className="text-sm text-blue-600 hover:text-blue-700 font-medium">View All</a></Link>
      </div>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
        {products.map((product) => <ProductCard key={product.id} product={product} />)}
      </div>
    </section>
  );
}
