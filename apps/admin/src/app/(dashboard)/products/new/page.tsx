import { PageHeader, ErrorState } from '@/components/ui/admin';
import { requireAdmin } from '@/lib/services';
import { ProductForm } from '@/components/products/ProductForm';
import { tryApi } from '@/lib/api/client';
import * as api from '@/lib/api/endpoints';
import { operatorMessage } from '@/lib/api/errors';
import Link from 'next/link';

/**
 * A new product.
 *
 * The category list is a HARD requirement, not a convenience: `categoryId` is
 * required by the API and there is no free-text fallback, so a form rendered
 * without categories is a form that cannot be submitted. It says so instead of
 * offering an empty dropdown and a validation error on save.
 */
export default async function NewProductPage() {
  await requireAdmin();

  const [categoriesRes, brandsRes] = await Promise.all([
    tryApi(() => api.listAdminCategories()),
    tryApi(() => api.listAdminBrands()),
  ]);

  const categories = categoriesRes.ok
    ? categoriesRes.data.data.filter((category) => category.deletedAt === null)
    : [];
  const brands = brandsRes.ok ? brandsRes.data.data.filter((brand) => brand.deletedAt === null) : [];

  if (!categoriesRes.ok || categories.length === 0) {
    return (
      <div className="space-y-6">
        <PageHeader title="New product" description="Start with the right category for your product." />
        <ErrorState title={categoriesRes.ok ? 'There are no categories yet' : 'Categories could not be loaded'} description={<>{categoriesRes.ok
              ? 'Every product belongs to a category, so one has to exist before a product can be created.'
              : operatorMessage(categoriesRes.error)}</>}><Link className="admin-link" href="/categories">Manage categories</Link></ErrorState>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PageHeader title={<>New product</>} description={<>Saved as a draft. Images and stock come next, then publish.</>} />
      <ProductForm mode="create" categories={categories} brands={brands} />
    </div>
  );
}
