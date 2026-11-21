/** Separate opt-in credentials: application/production credentials are never a fallback. */
export function testCloudinaryCredentials(env: NodeJS.ProcessEnv = process.env): {
  cloudName: string;
  apiKey: string;
  apiSecret: string;
} {
  const cloudName = env['NEST_TEST_CLOUDINARY_CLOUD_NAME'];
  const apiKey = env['NEST_TEST_CLOUDINARY_API_KEY'];
  const apiSecret = env['NEST_TEST_CLOUDINARY_API_SECRET'];
  if (
    env['CLOUDINARY_INTEGRATION'] !== '1' ||
    env['NEST_TEST_CLOUDINARY_ACCOUNT'] !== 'dedicated-disposable-account' ||
    !cloudName ||
    !apiKey ||
    !apiSecret ||
    cloudName === env['CLOUDINARY_CLOUD_NAME']
  ) {
    throw new Error(
      'Cloudinary tests require explicit opt-in, dedicated test-account attestation and separate NEST_TEST_CLOUDINARY_* credentials. Shared application accounts are forbidden.',
    );
  }
  return { cloudName, apiKey, apiSecret };
}

/** Successful uploads, not remote listing or a prefix alone, authorize cleanup. */
export class OwnedTestMedia {
  private readonly created = new Set<string>();
  constructor(readonly prefix: string) {}
  assertPrefix(id: string): void {
    if (!id.startsWith(this.prefix + '/'))
      throw new Error('Media operation outside this test run refused.');
  }
  record(id: string): void {
    this.assertPrefix(id);
    this.created.add(id);
  }
  assertCreated(id: string): void {
    this.assertPrefix(id);
    if (!this.created.has(id))
      throw new Error('Cannot delete media this run did not successfully upload.');
  }
  ids(): readonly string[] {
    return [...this.created];
  }
}
