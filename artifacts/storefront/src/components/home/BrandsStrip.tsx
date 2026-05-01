import { Link } from 'wouter';

interface Brand { id: string; name_en: string; slug: string; }

export function BrandsStrip({ brands }: { brands: Brand[] }) {
  if (!brands.length) return null;
  return (
    <section className="bg-slate-50 border-y border-slate-200 py-6">
      <div className="container-nest">
        <div className="flex items-center gap-3 overflow-x-auto scrollbar-none pb-1">
          {brands.map((brand) => (
            <Link
              key={brand.id}
              href={`/brands/${brand.slug}`}
              className="flex-shrink-0 px-5 py-2.5 bg-white border border-slate-200 rounded-md text-sm font-semibold text-slate-500 hover:text-blue-600 hover:border-blue-400 hover:shadow-sm transition-all"
            >
              {brand.name_en}
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
