import { Link } from 'wouter';

interface Brand { id: string; name_en: string; slug: string; }

export function BrandsStrip({ brands }: { brands: Brand[] }) {
  if (!brands.length) return null;
  return (
    <section className="bg-white border-y border-[#ebebeb] py-6">
      <div className="container-nest">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-heading font-bold text-[#0D0625] text-base">Our Brands</h3>
          <Link href="/products" className="text-sm text-[#E14A5C] font-semibold hover:underline">View All →</Link>
        </div>
        <div className="flex items-center gap-3 overflow-x-auto scrollbar-none pb-1">
          {brands.map((brand) => (
            <Link
              key={brand.id}
              href={`/brands/${brand.slug}`}
              className="flex-shrink-0 px-5 py-2 bg-[#f8f8f8] border border-[#e8e8e8] rounded-md text-sm font-semibold text-[#555] hover:text-[#E14A5C] hover:border-[#E14A5C] hover:bg-[#fde8ea] transition-all duration-150"
            >
              {brand.name_en}
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
