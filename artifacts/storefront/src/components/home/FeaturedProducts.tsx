import { useState } from 'react';
import { Link } from 'wouter';
import { ProductCard, ProductCardSkeleton, type ProductCardDTO } from '@/components/ProductCard';

interface FeaturedProductsProps {
  featured: ProductCardDTO[];
  topRated: ProductCardDTO[];
  newArrivals: ProductCardDTO[];
}

type Tab = 'popular' | 'rated' | 'new';

export function FeaturedProducts({ featured = [], topRated = [], newArrivals = [] }: FeaturedProductsProps) {
  const [tab, setTab] = useState<Tab>('popular');

  const products = tab === 'popular' ? featured : tab === 'rated' ? topRated : newArrivals;

  if (!featured.length && !topRated.length && !newArrivals.length) return null;

  const tabs: { key: Tab; label: string; href: string }[] = [
    { key: 'popular', label: 'Popular Products', href: '/products?sort=newest' },
    { key: 'rated', label: 'Top Rated', href: '/products?sort=rating' },
    { key: 'new', label: 'New Arrivals', href: '/products?sort=newest' },
  ];

  return (
    <section className="bg-white section-gap">
      <div className="container-nest">
        {/* Header with tabs */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-6 border-b border-[#e8e8e8] pb-0">
          <div className="flex items-end gap-0">
            {tabs.map((t) => (
              <button
                key={t.key}
                onClick={() => setTab(t.key)}
                className={`px-5 py-3 text-sm font-semibold border-b-2 transition-all duration-150 ${
                  tab === t.key
                    ? 'border-[#E14A5C] text-[#E14A5C]'
                    : 'border-transparent text-[#666] hover:text-[#0D0625]'
                }`}
              >
                {t.label}
              </button>
            ))}
          </div>
          <Link
            href={tabs.find((t) => t.key === tab)?.href ?? '/products'}
            className="text-sm text-[#E14A5C] font-semibold hover:underline whitespace-nowrap pb-3"
          >
            View All →
          </Link>
        </div>

        {/* Product grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {products.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
          {products.length === 0 &&
            Array.from({ length: 5 }).map((_, i) => <ProductCardSkeleton key={i} />)}
        </div>
      </div>
    </section>
  );
}

export function FeaturedProductsSkeleton() {
  return (
    <section className="bg-white section-gap">
      <div className="container-nest">
        <div className="flex items-center gap-0 mb-6 border-b border-[#e8e8e8] pb-0">
          {['Popular Products', 'Top Rated', 'New Arrivals'].map((label) => (
            <div key={label} className="px-5 py-3 h-4 w-28 bg-[#f0f0f0] animate-pulse rounded mx-1" />
          ))}
        </div>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {Array.from({ length: 5 }).map((_, i) => <ProductCardSkeleton key={i} />)}
        </div>
      </div>
    </section>
  );
}
