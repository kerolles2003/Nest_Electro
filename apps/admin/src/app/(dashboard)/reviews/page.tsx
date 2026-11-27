import { PageHeader, ErrorState } from '@/components/ui/admin';
import { requireAdmin, getAdminServices } from '@/lib/services';
import { DomainNotLiveNotice } from '@/components/system/DomainNotLiveNotice';
import { Suspense } from 'react';
import { ReviewsTable } from '@/components/reviews/ReviewsTable';

function ReviewsSkeleton() {
  return (
    <div className="space-y-5 animate-pulse">
      <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
        {Array.from({ length: 5 }).map((_, i) => (
          <div key={i} className="rounded-xl border border-border bg-card p-4 h-20" />
        ))}
      </div>
      <div className="rounded-xl border border-border bg-card h-12" />
      <div className="rounded-xl border border-border bg-card h-96" />
    </div>
  );
}

export default async function ReviewsPage(props: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  await requireAdmin();
  /*
   * Reviews are a Phase 8 domain (see DomainNotLiveNotice): this screen
   * still reads the legacy Supabase service because the API has no review
   * model yet. When that service is not configured in this deployment at
   * all, client construction throws — and an unhandled throw here used to
   * take the whole route down as an RSC render error, hiding the notice
   * that explains the domain's state. Render the notice and the error
   * state the page already uses for query failures instead.
   */
  let supabase: Awaited<ReturnType<typeof getAdminServices>>['supabase'];
  try {
    ({ supabase } = await getAdminServices());
  } catch {
    return (
      <div className="space-y-5">
        <DomainNotLiveNotice domain="reviews" />
        <PageHeader title={<>Reviews</>} description={<>Moderate product reviews and manage the approval queue.</>} />
        <ErrorState title="Reviews could not be loaded" description="The legacy service is not configured in this deployment. Reviews become available when the domain ships in Phase 8." />
      </div>
    );
  }
  const sp = await props.searchParams;

  const page = Number(sp.page) || 1;
  const search = (sp.search as string) || '';
  const statusFilter = (sp.status as string) || '';
  const limit = 25;

  let query = (supabase as any)
    .from('reviews')
    .select(
      `*, product:products(name_en, slug), profiles(full_name, avatar_url)`,
      { count: 'exact' }
    );

  if (search) {
    query = query.or(`product.name_en.ilike.%${search}%,profiles.full_name.ilike.%${search}%`);
  }
  if (statusFilter) {
    query = query.eq('moderation_status', statusFilter);
  }

  const { data, count, error } = await query
    .range((page - 1) * limit, page * limit - 1)
    .order('created_at', { ascending: false });

  const reviews = data ?? [];
  const total = count ?? 0;
  const totalPages = Math.ceil(total / limit);

  /* Stats */
  const { count: totalCount } = await (supabase as any)
    .from('reviews')
    .select('*', { count: 'exact', head: true });

  const { count: pendingCount } = await (supabase as any)
    .from('reviews')
    .select('*', { count: 'exact', head: true })
    .eq('moderation_status', 'pending');

  const { count: approvedCount } = await (supabase as any)
    .from('reviews')
    .select('*', { count: 'exact', head: true })
    .eq('moderation_status', 'approved');

  const { count: rejectedCount } = await (supabase as any)
    .from('reviews')
    .select('*', { count: 'exact', head: true })
    .eq('moderation_status', 'rejected');

  const { count: verifiedCount } = await (supabase as any)
    .from('reviews')
    .select('*', { count: 'exact', head: true })
    .eq('is_verified_purchase', true);

  return (
    <div className="space-y-5">
      <DomainNotLiveNotice domain="reviews" />

      <PageHeader title={<>Reviews</>} description={<>Moderate product reviews and manage the approval queue.</>} />

      {error ? <ErrorState title="Reviews could not be loaded" description="The legacy service did not respond. Try again in a moment." /> : <Suspense fallback={<ReviewsSkeleton />}>
        <ReviewsTable
          initialReviews={reviews}
          currentPage={page}
          totalPages={totalPages}
          total={total}
          stats={{
            total: totalCount ?? 0,
            pending: pendingCount ?? 0,
            approved: approvedCount ?? 0,
            rejected: rejectedCount ?? 0,
            verified: verifiedCount ?? 0,
          }}
        />
      </Suspense>}
    </div>
  );
}
