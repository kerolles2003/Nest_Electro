import { Controller, Get, Inject, NotFoundException, Param, Res } from '@nestjs/common';
import { ApiExcludeController } from '@nestjs/swagger';
import type { Response } from 'express';
import { Public } from '../../../common/decorators/public.decorator';
import { mediaConfig, type MediaConfig } from '../../../config/media.config';
import { LocalMediaStorage } from '../../../providers/media/local/local-media-storage';
import { MediaAssetRepository } from '../infrastructure/repositories/media-asset.repository';

/**
 * Byte delivery for the `local` media provider.
 *
 * Under Cloudinary this controller has nothing to do — the CDN serves the
 * bytes and the frontends build its URLs. Under `local`, the bytes live on
 * this host's disk (see LocalMediaStorage) and SOMETHING must serve them;
 * this is that something. It is deliberately not part of the JSON API
 * contract (`@ApiExcludeController`): it is a file route, not an API.
 *
 * ## URL shape
 *
 * Mirrors the Cloudinary shape the frontends already build:
 *   /media-delivery/v<version>/<publicId>   (versioned, cache-busting)
 *   /media-delivery/<publicId>              (version-less, cart lines)
 *
 * ## What authorises a response
 *
 * The reference LEDGER, not the filesystem. A publicId is served only when
 * a MediaAsset row names it — an orphan file on disk (uploaded, then its
 * product import rolled back) is not reachable, and a ledger row whose
 * file has gone missing is a 404 the reconciliation report can see. The
 * format — and therefore the Content-Type and the on-disk extension —
 * comes from the ledger row, never from the URL (MEDIA-MODEL.md §4: the
 * client is never the authority for media metadata).
 *
 * The version segment is accepted and not compared: locally only the
 * current bytes exist, so an older version's URL serves the current asset.
 * The URL still busts caches correctly, because a re-upload changes the
 * version in every NEW URL the API hands out. (Cloudinary keeps every
 * version; this difference is one of the reasons `local` is refused in
 * production.)
 *
 * Responses are public — product photographs are public on the storefront
 * by design, exactly as they are on the CDN — and immutable-cached, which
 * the versioned URL makes safe.
 */
@ApiExcludeController()
@Public()
@Controller('media-delivery')
export class MediaDeliveryController {
  constructor(
    @Inject(mediaConfig.KEY) private readonly config: MediaConfig,
    private readonly assets: MediaAssetRepository,
    private readonly storage: LocalMediaStorage,
  ) {}

  @Get('*path')
  async deliver(@Param('path') path: string[], @Res() response: Response): Promise<void> {
    if (this.config.provider !== 'local') {
      throw new NotFoundException();
    }

    const segments = [...path];
    if (segments.length > 0 && /^v\d+$/.test(segments[0] ?? '')) {
      segments.shift();
    }
    const publicId = segments.join('/');

    // Same shape the upload pipeline generates and the attach DTO validates:
    // lowercase words, digits, `/`, `-`, `_` — no dots, so no traversal and
    // no extension smuggled in through the URL.
    if (!/^[A-Za-z0-9][A-Za-z0-9_-]*(?:\/[A-Za-z0-9_-]+)+$/.test(publicId)) {
      throw new NotFoundException();
    }

    const asset = await this.assets.find(publicId);
    if (asset === null) {
      throw new NotFoundException();
    }

    const bytes = await this.storage.read(publicId, asset.format);
    if (bytes === undefined) {
      throw new NotFoundException();
    }

    const contentType =
      asset.format === 'webp'
        ? 'image/webp'
        : asset.format === 'png'
          ? 'image/png'
          : 'image/jpeg';

    response
      .status(200)
      .setHeader('Content-Type', contentType)
      .setHeader('Content-Length', String(bytes.length))
      .setHeader('Cache-Control', 'public, max-age=31536000, immutable')
      // The storefront and admin are different origins from this API, and
      // helmet's global `Cross-Origin-Resource-Policy: same-origin` would
      // make the browser refuse to embed these bytes as <img> at all. The
      // assets are public by design (above), so — exactly as a CDN would —
      // this route alone opts into cross-origin embedding.
      .setHeader('Cross-Origin-Resource-Policy', 'cross-origin')
      .send(bytes);
  }
}
