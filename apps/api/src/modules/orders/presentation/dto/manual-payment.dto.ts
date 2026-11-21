import { ApiProperty } from '@nestjs/swagger';
import { PaymentMethod } from '../../domain/order-status';

/**
 * Manual payment availability and instructions (D01/D03/D16).
 *
 * Values are owner-configured receiving details, or null when the method is
 * not offered. This is public checkout information — the same details the
 * store prints on its payment instructions — never a credential.
 */
export class ManualPaymentInstructionsDto {
  @ApiProperty({ type: [String], enum: PaymentMethod, example: [PaymentMethod.COD] })
  availableMethods!: PaymentMethod[];

  @ApiProperty({ example: null, nullable: true, type: String })
  walletNumber!: string | null;

  @ApiProperty({ example: null, nullable: true, type: String })
  instapayAddress!: string | null;

  @ApiProperty({ example: null, nullable: true, type: String })
  whatsappNumber!: string | null;
}

export class ManualPaymentInstructionsResponseDto {
  @ApiProperty({ type: ManualPaymentInstructionsDto })
  data!: ManualPaymentInstructionsDto;
}
