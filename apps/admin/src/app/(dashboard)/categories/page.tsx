import { PageHeader, ErrorState } from '@/components/ui/admin';
import { requireAdmin } from '@/lib/services';
import { CategoriesManager } from '@/components/categories/CategoriesManager';
import { tryApi } from '@/lib/api/client';
import * as api from '@/lib/api/endpoints';
import { operatorMessage } from '@/lib/api/errors';

/**
 * Categories, from the API.
 *
 * `includeDeleted=true` on purpose. A deleted category keeps its slug reserved,
 * so it is not gone — it is holding a name — and hiding it would leave an
 * operator unable to work out why a slug they want is refused. It renders
 * greyed with a Restore action.
 *
 * The list arrives FLAT and shallowest-first, each row carrying `parentId`,
 * `path` and `depth`. No tree is built here: indentation is `depth`, and
 * reconstructing a `children` array would be redoing what the server resolved.
 */
export default async function CategoriesPage() {
  await requireAdmin();

  const res = await tryApi(() => api.listAdminCategories({ includeDeleted: true }));

  return (
    <div className="space-y-5">
      <PageHeader title={<>Categories</>} description="Organize products into a clear, easy-to-browse catalogue." />

      {res.ok ? (
        <CategoriesManager categories={res.data.data} />
      ) : (
        <ErrorState title="Categories could not be loaded" description={<>{operatorMessage(res.error)}</>} />
      )}
    </div>
  );
}
