import { afterEach, beforeEach, describe, expect, it } from '@jest/globals';
import { NotFoundException } from '@nestjs/common';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import type { Response } from 'express';
import type { MediaConfig } from '../../src/config/media.config';
import type { MediaAssetRepository } from '../../src/modules/media/infrastructure/repositories/media-asset.repository';
import { MediaDeliveryController } from '../../src/modules/media/presentation/media-delivery.controller';
import { LocalMediaStorage } from '../../src/providers/media/local/local-media-storage';

/**
 * The local delivery route, at controller level. The bug this guards: the
 * route shipped WITHOUT the project's @Public() opt-out, so the global
 * auth guard answered every image request with 401 and the whole local
 * catalogue rendered placeholders — while every adapter-level test passed.
 * These cases pin the route's own contract: ledger-authorised, provider-
 * gated, versioned and version-less shapes, and 404 for anything else.
 */

function png(width: number, height: number): Buffer {
  const buffer = Buffer.alloc(33);
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]).copy(buffer, 0);
  buffer.writeUInt32BE(13, 8);
  buffer.write('IHDR', 12, 'ascii');
  buffer.writeUInt32BE(width, 16);
  buffer.writeUInt32BE(height, 20);
  return buffer;
}

interface Captured {
  status?: number;
  headers: Record<string, string>;
  body?: Buffer;
}

function fakeResponse(): { res: Response; captured: Captured } {
  const captured: Captured = { headers: {} };
  const res = {
    status(code: number) {
      captured.status = code;
      return this;
    },
    setHeader(name: string, value: string) {
      captured.headers[name.toLowerCase()] = value;
      return this;
    },
    send(body: Buffer) {
      captured.body = body;
      return this;
    },
  };
  return { res: res as unknown as Response, captured };
}

describe('MediaDeliveryController', () => {
  let root: string;
  let storage: LocalMediaStorage;
  const bytes = png(640, 480);
  const publicId = 'nest/products/abc123/img1';
  const ledgerRow = { publicId, format: 'png', version: 42 };

  const repository = {
    find: async (id: string) => (id === publicId ? ledgerRow : null),
  } as unknown as MediaAssetRepository;

  const controller = (provider: string) =>
    new MediaDeliveryController(
      { provider } as unknown as MediaConfig,
      repository,
      storage,
    );

  beforeEach(async () => {
    root = await mkdtemp(join(tmpdir(), 'nest-delivery-'));
    storage = new LocalMediaStorage(root);
    await storage.upload({ publicId, format: 'png', bytes });
  });

  afterEach(async () => {
    await rm(root, { recursive: true, force: true });
  });

  it('serves a versioned URL with the ledger format and immutable caching', async () => {
    const { res, captured } = fakeResponse();
    await controller('local').deliver(['v42', 'nest', 'products', 'abc123', 'img1'], res);

    expect(captured.status).toBe(200);
    expect(captured.headers['content-type']).toBe('image/png');
    expect(captured.headers['cache-control']).toContain('immutable');
    // Without this, helmet's global same-origin CORP makes the browser
    // refuse to embed the bytes cross-origin (ERR_BLOCKED_BY_RESPONSE).
    expect(captured.headers['cross-origin-resource-policy']).toBe('cross-origin');
    expect(captured.body?.equals(bytes)).toBe(true);
  });

  it('serves the version-less shape used by cart lines', async () => {
    const { res, captured } = fakeResponse();
    await controller('local').deliver(['nest', 'products', 'abc123', 'img1'], res);

    expect(captured.status).toBe(200);
    expect(captured.body?.equals(bytes)).toBe(true);
  });

  it('404s when the provider is not local — delivery belongs to the CDN', async () => {
    const { res } = fakeResponse();
    await expect(
      controller('cloudinary').deliver(['v42', 'nest', 'products', 'abc123', 'img1'], res),
    ).rejects.toBeInstanceOf(NotFoundException);
  });

  it('404s for a publicId the ledger does not know, even if a file existed', async () => {
    const { res } = fakeResponse();
    await expect(
      controller('local').deliver(['v1', 'nest', 'products', 'unknown', 'img9'], res),
    ).rejects.toBeInstanceOf(NotFoundException);
  });

  it('404s when the ledger knows the asset but the bytes are gone', async () => {
    await storage.destroy(publicId);
    const { res } = fakeResponse();
    await expect(
      controller('local').deliver(['v42', 'nest', 'products', 'abc123', 'img1'], res),
    ).rejects.toBeInstanceOf(NotFoundException);
  });

  it('404s for a malformed identifier instead of touching the filesystem', async () => {
    const { res } = fakeResponse();
    await expect(
      controller('local').deliver(['..', '..', 'etc', 'passwd'], res),
    ).rejects.toBeInstanceOf(NotFoundException);
  });
});
