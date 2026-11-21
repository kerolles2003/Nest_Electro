import Link from 'next/link';

/**
 * Page navigation for the simple listing pages (category, brand).
 *
 * F18: these pages used to request page 1 with a limit of 24 and render
 * whatever came back, so every product past the 24th was unreachable even
 * though the API reported the true total. The links are plain `?page=`
 * navigations — the page is a Server Component and re-queries the API for
 * the requested page, exactly like the main listing.
 */
export function ListingPagination({
  basePath,
  page,
  totalPages,
}: {
  basePath: string;
  page: number;
  totalPages: number;
}) {
  if (totalPages <= 1) return null;

  const pages = Array.from({ length: totalPages }, (_, i) => i + 1).slice(
    Math.max(0, page - 3),
    Math.min(totalPages, page + 2),
  );

  return (
    <nav className="mt-8 flex items-center justify-center gap-1" aria-label="Pagination">
      {page > 1 && (
        <Link
          href={`${basePath}?page=${page - 1}`}
          className="inline-flex h-8 w-8 items-center justify-center rounded-sm text-sm text-foreground-muted transition-colors hover:bg-surface"
        >
          ‹
        </Link>
      )}
      {pages.map((candidate) => (
        <Link
          key={candidate}
          href={`${basePath}?page=${candidate}`}
          aria-current={candidate === page ? 'page' : undefined}
          className={`inline-flex h-8 w-8 items-center justify-center rounded-sm text-xs font-medium transition-colors ${
            candidate === page
              ? 'bg-primary text-white'
              : 'text-foreground-muted hover:bg-surface'
          }`}
        >
          {candidate}
        </Link>
      ))}
      {page < totalPages && (
        <Link
          href={`${basePath}?page=${page + 1}`}
          className="inline-flex h-8 w-8 items-center justify-center rounded-sm text-sm text-foreground-muted transition-colors hover:bg-surface"
        >
          ›
        </Link>
      )}
    </nav>
  );
}

/** A `?page=` value as a usable page number: garbage becomes page 1. */
export function parsePageParam(raw: string | string[] | undefined): number {
  const value = Array.isArray(raw) ? raw[0] : raw;
  const parsed = Number.parseInt(value ?? '', 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 1;
}
