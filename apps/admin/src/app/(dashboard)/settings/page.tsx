import { requireAdmin } from "@/lib/services";
import { PageHeader, ErrorState } from "@/components/ui/admin";
import { tryApi } from "@/lib/api/client";
import * as api from "@/lib/api/endpoints";
import { ShippingRatesTable } from "@/components/settings/ShippingRatesTable";

export default async function SettingsPage() {
  await requireAdmin();

  const ratesRes = await tryApi(() => api.listShippingRates());
  const initialRates = ratesRes.ok ? ratesRes.data.data : [];

  return (
    <div className="space-y-6">
      <PageHeader
        title="Settings & Policies"
        description="Manage delivery fees for each governorate. Changes apply immediately at checkout."
      />
      {ratesRes.ok ? <ShippingRatesTable initialRates={initialRates} /> : <ErrorState title="Shipping rates could not be loaded" description={ratesRes.error.message} />}
    </div>
  );
}
