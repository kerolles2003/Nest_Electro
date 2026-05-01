import { useEffect, useState } from 'react';
import { Link } from 'wouter';
import { getSupabaseClient } from '@/lib/supabase';
import { Cpu, ChevronRight } from 'lucide-react';

interface Category { id: string; name_en: string; slug: string; parent_id: string | null; children?: Category[]; }

export default function CategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const supabase = getSupabaseClient();

  useEffect(() => {
    supabase.from('categories').select('id, name_en, slug, parent_id').eq('is_active', true).is('deleted_at', null).order('sort_order')
      .then(({ data }) => {
        const all = data ?? [];
        const roots = all.filter((c: Category) => !c.parent_id).map((r: Category) => ({
          ...r, children: all.filter((c: Category) => c.parent_id === r.id)
        }));
        setCategories(roots);
        setLoading(false);
      });
  }, []);

  return (
    <div className="container-nest py-8">
      <nav className="flex items-center gap-1.5 text-xs text-slate-500 mb-4">
        <Link href="/"><a className="hover:text-blue-600 transition-colors">Home</a></Link>
        <ChevronRight className="w-3 h-3" />
        <span className="text-slate-900 font-medium">All Categories</span>
      </nav>
      <h1 className="text-2xl font-heading font-semibold text-slate-900 mb-6">All Categories</h1>
      {loading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {Array.from({ length: 10 }).map((_, i) => <div key={i} className="h-32 bg-slate-100 animate-pulse rounded-lg" />)}
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {categories.map((cat) => (
            <Link key={cat.id} href={`/categories/${cat.slug}`}>
              <a className="bg-white border border-slate-200 rounded-lg p-5 hover:border-blue-400 hover:shadow-sm transition-all group">
                <div className="w-12 h-12 bg-blue-50 rounded-lg flex items-center justify-center text-blue-600 mb-3 group-hover:bg-blue-600 group-hover:text-white transition-colors">
                  <Cpu className="w-6 h-6" />
                </div>
                <h3 className="text-sm font-semibold text-slate-900 mb-1">{cat.name_en}</h3>
                <p className="text-xs text-slate-500">{cat.children?.length ?? 0} subcategories</p>
                {cat.children && cat.children.length > 0 && (
                  <div className="mt-3 pt-3 border-t border-slate-100 space-y-1">
                    {cat.children.slice(0, 3).map((sub) => (
                      <span key={sub.id} className="block text-xs text-slate-400 truncate">{sub.name_en}</span>
                    ))}
                    {cat.children.length > 3 && <span className="text-xs text-blue-600">+{cat.children.length - 3} more</span>}
                  </div>
                )}
              </a>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
