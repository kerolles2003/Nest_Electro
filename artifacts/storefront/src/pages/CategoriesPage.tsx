import { useEffect, useState } from 'react';
import { Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { Box, Cpu, Gauge, Zap, Radio, HardDrive, Wifi, Battery, Cable, ChevronRight } from 'lucide-react';

interface Category { id: string; name_en: string; slug: string; parent_id: string | null; children?: Category[]; }

const ICON_MAP: Record<string, React.ReactNode> = {
  'arduino-shields': <Cpu className="w-6 h-6" />,
  'sensors-modules': <Gauge className="w-6 h-6" />,
  'motors-drivers': <Zap className="w-6 h-6" />,
  'led-displays': <Radio className="w-6 h-6" />,
  'power-supplies': <Battery className="w-6 h-6" />,
  'connectors-cables': <Cable className="w-6 h-6" />,
  'wireless-communication': <Wifi className="w-6 h-6" />,
  'memory-storage': <HardDrive className="w-6 h-6" />,
};

export default function CategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const supabase = getSupabaseClient();

  useEffect(() => {
    supabase
      .from('categories')
      .select('id, name_en, slug, parent_id')
      .eq('is_active', true)
      .is('deleted_at', null)
      .order('sort_order')
      .then(({ data }: { data: Category[] | null }) => {
        const all = data ?? [];
        const roots = all
          .filter((c) => !c.parent_id)
          .map((r) => ({ ...r, children: all.filter((c) => c.parent_id === r.id) }));
        setCategories(roots);
        setLoading(false);
      });
  }, []);

  return (
    <div className="bg-[#f8f8f8] min-h-screen">
      <div className="container-nest py-8">
        <nav className="flex items-center gap-1.5 text-xs text-[#999] mb-4">
          <Link href="/" className="hover:text-[#E14A5C] transition-colors">Home</Link>
          <ChevronRight className="w-3 h-3" />
          <span className="text-[#0D0625] font-medium">All Categories</span>
        </nav>

        <h1 className="font-heading font-bold text-2xl text-[#0D0625] mb-6">All Categories</h1>

        {loading ? (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            {Array.from({ length: 10 }).map((_, i) => (
              <div key={i} className="h-36 bg-[#f0f0f0] animate-pulse rounded-lg" />
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            {categories.map((cat) => (
              <Link key={cat.id} href={`/categories/${cat.slug}`}>
                <div className="bg-white border border-[#e8e8e8] rounded-lg p-5 hover:border-[#E14A5C] hover:shadow-md transition-all group cursor-pointer">
                  <div className="w-12 h-12 bg-[#fde8ea] rounded-lg flex items-center justify-center text-[#E14A5C] mb-3 group-hover:bg-[#E14A5C] group-hover:text-white transition-colors duration-200">
                    {ICON_MAP[cat.slug] ?? <Box className="w-6 h-6" />}
                  </div>
                  <h3 className="text-sm font-semibold text-[#0D0625] mb-1 group-hover:text-[#E14A5C] transition-colors">{cat.name_en}</h3>
                  <p className="text-xs text-[#999]">{cat.children?.length ?? 0} subcategories</p>
                  {cat.children && cat.children.length > 0 && (
                    <div className="mt-3 pt-3 border-t border-[#f0f0f0] space-y-1">
                      {cat.children.slice(0, 3).map((sub) => (
                        <span key={sub.id} className="block text-xs text-[#aaa] truncate">{sub.name_en}</span>
                      ))}
                      {cat.children.length > 3 && (
                        <span className="text-xs text-[#E14A5C] font-medium">+{cat.children.length - 3} more</span>
                      )}
                    </div>
                  )}
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
