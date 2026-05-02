import { Link } from 'wouter';
import { Cpu, Gauge, Zap, Radio, HardDrive, Wifi, Battery, Cable, Box } from 'lucide-react';

interface Category { id: string; name_en: string; slug: string; parent_id?: string | null; children?: Category[]; }

const ICON_MAP: Record<string, React.ReactNode> = {
  'arduino-shields': <Cpu className="w-5 h-5" />,
  'sensors-modules': <Gauge className="w-5 h-5" />,
  'motors-drivers': <Zap className="w-5 h-5" />,
  'led-displays': <Radio className="w-5 h-5" />,
  'power-supplies': <Battery className="w-5 h-5" />,
  'connectors-cables': <Cable className="w-5 h-5" />,
  'wireless-communication': <Wifi className="w-5 h-5" />,
  'memory-storage': <HardDrive className="w-5 h-5" />,
};

export function CategoryGrid({ categories }: { categories: Category[] }) {
  const roots = categories.filter((c) => !c.parent_id);
  if (!roots.length) return null;
  return (
    <section className="bg-[#f8f8f8] border-t border-[#ebebeb] section-gap">
      <div className="container-nest">
        <div className="flex items-center justify-between mb-5">
          <h2 className="font-heading font-bold text-[#0D0625] text-xl">Shop by Category</h2>
          <Link href="/categories" className="text-sm text-[#E14A5C] font-semibold hover:underline">View All →</Link>
        </div>
        <div className="grid grid-cols-2 xs:grid-cols-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-3">
          {roots.map((cat) => (
            <Link
              key={cat.id}
              href={`/categories/${cat.slug}`}
              className="group flex flex-col items-center gap-2.5 p-4 bg-white border border-[#e8e8e8] rounded-lg hover:border-[#E14A5C] hover:shadow-sm transition-all duration-200 text-center"
            >
              <div className="w-10 h-10 bg-[#fde8ea] rounded-lg flex items-center justify-center text-[#E14A5C] group-hover:bg-[#E14A5C] group-hover:text-white transition-colors duration-200">
                {ICON_MAP[cat.slug] ?? <Box className="w-5 h-5" />}
              </div>
              <span className="text-[12px] font-medium text-[#333] group-hover:text-[#E14A5C] leading-tight transition-colors">{cat.name_en}</span>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
