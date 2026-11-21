import { describe, expect, it } from '@jest/globals';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { ArrangeImagesDto } from '../../src/modules/catalog/presentation/dto/admin-product-image.dto';

describe('arrangement version input contract', () => {
  const images = [{ publicId: 'nest/products/68b000000000000000000001/image-a' }];
  it.each([undefined, null, -1, 1.5, '1'])('rejects invalid expectedVersion %s', async expectedVersion => {
    const errors = await validate(plainToInstance(ArrangeImagesDto, { images, expectedVersion }));
    expect(errors.some(error => error.property === 'expectedVersion')).toBe(true);
  });
  it('accepts a nonnegative integer version', async () => {
    const errors = await validate(plainToInstance(ArrangeImagesDto, { images, expectedVersion: 0 }));
    expect(errors.some(error => error.property === 'expectedVersion')).toBe(false);
  });
});
