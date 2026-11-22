import { describe, expect, it } from '@jest/globals';
import {
  reconcileMedia,
  renderMediaReconciliation,
} from '../../src/modules/media/application/media-reconciliation';

/**
 * The reconciliation comparison is pure, so its contract is pinned here
 * without a database or a filesystem: the CLI's value depends entirely on
 * this diff being exact — an operator may delete files from its output.
 */
describe('reconcileMedia', () => {
  it('reports a clean state when disk and ledger agree', () => {
    const report = reconcileMedia(['a/1', 'a/2'], ['a/2', 'a/1']);
    expect(report.matched).toBe(2);
    expect(report.onDiskOnly).toEqual([]);
    expect(report.inLedgerOnly).toEqual([]);
    expect(report.diskTotal).toBe(2);
    expect(report.ledgerTotal).toBe(2);
  });

  it('names files with no live ledger row as on-disk only', () => {
    const report = reconcileMedia(['a/1', 'a/orphan'], ['a/1']);
    expect(report.onDiskOnly).toEqual(['a/orphan']);
    expect(report.inLedgerOnly).toEqual([]);
    expect(report.matched).toBe(1);
  });

  it('names live ledger rows with no file as in-ledger only', () => {
    const report = reconcileMedia(['a/1'], ['a/1', 'a/missing']);
    expect(report.inLedgerOnly).toEqual(['a/missing']);
    expect(report.onDiskOnly).toEqual([]);
  });

  it('handles both sides being empty', () => {
    const report = reconcileMedia([], []);
    expect(report.matched).toBe(0);
    expect(report.diskTotal).toBe(0);
    expect(report.ledgerTotal).toBe(0);
  });

  it('de-duplicates inputs so a repeated id cannot fake a match or a gap', () => {
    const report = reconcileMedia(['a/1', 'a/1', 'a/2'], ['a/1', 'a/1']);
    expect(report.diskTotal).toBe(2);
    expect(report.ledgerTotal).toBe(1);
    expect(report.matched).toBe(1);
    expect(report.onDiskOnly).toEqual(['a/2']);
  });

  it('sorts both output lists so reports diff cleanly between runs', () => {
    const report = reconcileMedia(['z/9', 'a/1', 'm/5'], ['y/8', 'b/2']);
    expect(report.onDiskOnly).toEqual(['a/1', 'm/5', 'z/9']);
    expect(report.inLedgerOnly).toEqual(['b/2', 'y/8']);
  });
});

describe('renderMediaReconciliation', () => {
  it('states plainly that nothing was changed and surfaces both counts', () => {
    const text = renderMediaReconciliation(reconcileMedia(['a/orphan'], []), 1234);
    expect(text).toContain('report only — nothing was changed');
    expect(text).toContain('on disk only     : 1 file(s), 1234 byte(s)');
    expect(text).toContain('a/orphan');
  });

  it('flags ledger-only rows as broken', () => {
    const text = renderMediaReconciliation(reconcileMedia([], ['a/missing']), 0);
    expect(text).toContain('BROKEN');
    expect(text).toContain('a/missing');
  });
});
