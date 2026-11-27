import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsString, MaxLength } from 'class-validator';

const trim = ({ value }: { value: unknown }): unknown =>
  typeof value === 'string' ? value.trim() : value;

/**
 * Resubmit manual-transfer evidence after a rejection (D03).
 *
 * Carries the corrected sender account only. Evidence never changes the
 * payment state by itself: resubmission returns the order to
 * PENDING_VERIFICATION, and only an authorized admin approval can move it
 * to PAID.
 */
export class ResubmitPaymentDto {
  @ApiProperty({
    example: '01012345678',
    maxLength: 64,
    description: 'The wallet number or InstaPay account the (new) transfer was sent FROM.',
  })
  @IsString()
  @Transform(trim)
  @MaxLength(64, { message: 'transferSender must not exceed 64 characters' })
  transferSender!: string;
}
