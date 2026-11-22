/**
 * Media reconciliation: the local disk against the ledger.
 *
 * The ledger (`MediaAsset`) is the authority for what may be served — the
 * delivery controller refuses any `publicId` without a live ledger row, so a
 * file on disk with no row is unreachable bytes, and a live row with no file
 * is a broken image waiting for a customer to find it. Development machines
 * accumulate the first kind quickly: every catalogue rebuild uploads fresh
 * copies and orphans the previous set.
 *
 * This module is the pure comparison. It decides nothing and deletes
 * nothing: it names the two sets so an operator (or the owner) can decide
 * from an exact list instead of a guess. The CLI in
 * `src/database/media/media-reconcile.ts` gathers the inputs and prints the
 * rendering produced here.
 */
export interface MediaReconciliation {
  /** Files on disk with no live ledger row. Not servable; pure disk usage. */
  readonly onDiskOnly: readonly string[];
  /** Live ledger rows whose file is missing. These ARE servable in principle — and broken. */
  readonly inLedgerOnly: readonly string[];
  /** Count of publicIds present in both. */
  readonly matched: number;
  /** Total files seen on disk (after de-duplication). */
  readonly diskTotal: number;
  /** Total live ledger rows considered. */
  readonly ledgerTotal: number;
}

/**
 * Compare the disk's publicIds against the ledger's LIVE publicIds.
 *
 * Callers pass live rows only (destroyedAt unset): a destroyed row's file is
 * expected to be gone, so a file that still exists for a destroyed row is
 * correctly reported as on-disk-only — the destroy path failed to remove it,
 * which is exactly the kind of residue this report exists to surface.
 *
 * Inputs may contain duplicates (a directory walk cannot produce them, but a
 * hand-built list can); both sides are de-duplicated before comparison so a
 * duplicate can never masquerade as a match or a gap. Output lists are
 * sorted, so two runs over the same state render identically and diff
 * cleanly.
 */
export function reconcileMedia(
  diskPublicIds: readonly string[],
  liveLedgerPublicIds: readonly string[],
): MediaReconciliation {
  const disk = new Set(diskPublicIds);
  const ledger = new Set(liveLedgerPublicIds);

  const onDiskOnly = [...disk].filter((id) => !ledger.has(id)).sort();
  const inLedgerOnly = [...ledger].filter((id) => !disk.has(id)).sort();

  return {
    onDiskOnly,
    inLedgerOnly,
    matched: disk.size - onDiskOnly.length,
    diskTotal: disk.size,
    ledgerTotal: ledger.size,
  };
}

/** Render the report an operator reads. `orphanBytes` is the summed size of the on-disk-only files. */
export function renderMediaReconciliation(
  report: MediaReconciliation,
  orphanBytes: number,
): string {
  const lines: string[] = [
    'Media reconciliation (report only — nothing was changed)',
    `  live ledger rows : ${String(report.ledgerTotal)}`,
    `  files on disk    : ${String(report.diskTotal)}`,
    `  matched          : ${String(report.matched)}`,
    `  on disk only     : ${String(report.onDiskOnly.length)} file(s), ${String(orphanBytes)} byte(s) — not servable (no live ledger row)`,
    `  in ledger only   : ${String(report.inLedgerOnly.length)} row(s) — live rows whose file is missing`,
  ];
  if (report.onDiskOnly.length > 0) {
    lines.push('', 'On disk only:');
    for (const id of report.onDiskOnly) lines.push(`  ${id}`);
  }
  if (report.inLedgerOnly.length > 0) {
    lines.push('', 'In ledger only (BROKEN — investigate before anything else):');
    for (const id of report.inLedgerOnly) lines.push(`  ${id}`);
  }
  return lines.join('\n');
}
