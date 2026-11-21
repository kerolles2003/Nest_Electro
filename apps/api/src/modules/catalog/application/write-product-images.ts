import type { ClientSession, Model, Types } from 'mongoose';
import { AppException } from '../../../common/errors/app.exception';
import type { Product, ProductLean } from '../infrastructure/schemas/product.schema';

/** Shared compare-and-swap for admin and import image arrangements. */
export async function writeProductImages(
  products: Model<Product>,
  productId: Types.ObjectId,
  images: readonly object[],
  expectedVersion: number,
  session?: ClientSession,
): Promise<ProductLean> {
  if (!Number.isSafeInteger(expectedVersion) || expectedVersion < 0) {
    throw AppException.concurrentModification();
  }
  const updated = await products.findOneAndUpdate(
    { _id: productId, deletedAt: null, $or: expectedVersion === 0
      ? [{ imageVersion: 0 }, { imageVersion: { $exists: false } }]
      : [{ imageVersion: expectedVersion }] },
    { $set: { images }, $inc: { imageVersion: 1 } },
    { new: true, session: session ?? null },
  ).lean<ProductLean>().exec();
  if (updated === null) throw AppException.concurrentModification();
  return updated;
}
