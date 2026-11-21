import { PageHeader, ErrorState } from '@/components/ui/admin';
import { requireAdmin } from '@/lib/services';
import { ProductForm } from '@/components/products/ProductForm';
import { tryApi } from '@/lib/api/client';
import * as api from '@/lib/api/endpoints';
import { operatorMessage } from '@/lib/api/errors';
import { notFound } from 'next/navigation';
import Link from 'next/link';

/**
 * One product.
 *
 * A soft-deleted product resolves here and is NOT a 404 — the restore action is
 * reached from the catalogue's Deleted tab, and an operator who follows a link
 * to a deleted product needs to be told that is what it is rather than that it
 * never existed. The form renders it read-only-ish with a banner saying so.
 *
 * A genuine 404 from the API is a genuine 404 here. Anything else — the API
 * being unreachable, a 500 — is stated as a failure, because "this product does
 * not exist" is a claim, and making it because a fetch failed is how somebody
 * concludes their catalogue has lost a row.
 */
export default async function EditProductPage(props: { params: Promise<{ id: string }> }) {
  await requireAdmin();
  const { id } = await props.params;

  const [productRes, categoriesRes, brandsRes] = await Promise.all([
    tryApi(() => api.getAdminProduct(id)),
    tryApi(() => api.listAdminCategories()),
    tryApi(() => api.listAdminBrands()),
  ]);

  if (!productRes.ok) {
    if (productRes.error.status === 404) notFound();

    return (
      <div className="space-y-6">
        <PageHeader title="Product" />
        <ErrorState title="This product could not be loaded" description={<>{operatorMessage(productRes.error)}</>}>
          <Link href="/products" className="admin-link">Back to catalogue</Link>
        </ErrorState>
      </div>
    );
  }

  const product = productRes.data.data;

  const categories = categoriesRes.ok
    ? categoriesRes.data.data.filter(
        // A soft-deleted category is excluded from the picker but kept if it is
        // the one this product is already in: dropping it would make the select
        // fall back to the first option and silently re-file the product on the
        // next save.
        (category) => category.deletedAt === null || category.id === product.category.id,
      )
    : [];
  const brands = brandsRes.ok
    ? brandsRes.data.data.filter(
        (brand) => brand.deletedAt === null || brand.id === product.brand?.id,
      )
    : [];

  return (
    <div className="space-y-6">
      <PageHeader title={<>{product.name.en}</>} description={<>{product.sku}</>} />
      <ProductForm mode="edit" categories={categories} brands={brands} product={product} />
    </div>
  );
}
