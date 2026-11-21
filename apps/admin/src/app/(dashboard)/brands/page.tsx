import { PageHeader, ErrorState } from '@/components/ui/admin';
import { requireAdmin } from '@/lib/services';
import { BrandsManager } from '@/components/brands/BrandsManager';
import { tryApi } from '@/lib/api/client';
import * as api from '@/lib/api/endpoints';
import { operatorMessage } from '@/lib/api/errors';

/**
 * Brands, from the API.
 *
 * `includeDeleted=true` for the same reason as categories: a deleted brand
 * keeps its slug reserved, so hiding it would leave an operator unable to work
 * out why the name they want is refused.
 */
export default async function BrandsPage() {
  await requireAdmin();

  const res = await tryApi(() => api.listAdminBrands({ includeDeleted: true }));

  return (
    <div className="space-y-5">
      <PageHeader title={<>Brands</>} description="Manage the brands represented in your store." />

      {res.ok ? (
        <BrandsManager brands={res.data.data} />
      ) : (
        <ErrorState title="Brands could not be loaded" description={<>{operatorMessage(res.error)}</>} />
      )}
    </div>
  );
}
