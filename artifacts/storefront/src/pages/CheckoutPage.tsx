import React, { useState, useCallback } from 'react';
import { Link } from 'wouter';
import { ShoppingBag, Check, MapPin, ClipboardList, PackageCheck, Loader2 } from 'lucide-react';
import { useCartStore } from '@/stores/cart-store';
import { QuantitySelector } from '@/components/QuantitySelector';
import { EGYPTIAN_GOVERNORATES, ROUTES } from '@/lib/constants';
import { getSupabaseClient } from '@/lib/supabase';

type ShippingFormData = {
  full_name: string; phone: string; street: string;
  city: string; governorate: string; postal_code: string;
};

const emptyShipping: ShippingFormData = { full_name: '', phone: '', street: '', city: '', governorate: '', postal_code: '' };

const INPUT_CLASS = 'w-full border border-[#e0e0e0] rounded-md px-3 py-2.5 text-sm text-[#0D0625] placeholder:text-[#aaa] focus:border-[#E14A5C] focus:outline-none focus:ring-2 focus:ring-[#E14A5C]/10 transition-colors bg-white';

const STEPS = [
  { label: 'Shipping',     icon: MapPin },
  { label: 'Review',       icon: ClipboardList },
  { label: 'Confirmation', icon: PackageCheck },
] as const;

export default function CheckoutPage() {
  const { items, updateQuantity, getTotalPrice, clearCart } = useCartStore();
  const [step, setStep] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [orderError, setOrderError] = useState<string | null>(null);
  const [orderNumber, setOrderNumber] = useState<string | null>(null);
  const [shippingData, setShippingData] = useState<ShippingFormData>(emptyShipping);

  const subtotal = getTotalPrice();
  const SHIPPING_FEE = 50;

  const updateField = useCallback((field: keyof ShippingFormData, value: string) => {
    setShippingData((prev) => ({ ...prev, [field]: value }));
  }, []);

  const isShippingFormValid =
    shippingData.full_name.trim().length >= 2 &&
    shippingData.phone.trim().length > 0 &&
    shippingData.street.trim().length >= 5 &&
    shippingData.city.trim().length >= 2 &&
    shippingData.governorate.length > 0;

  const handlePlaceOrder = async () => {
    setIsSubmitting(true);
    setOrderError(null);
    try {
      const supabase = getSupabaseClient();
      const { data: { session } } = await supabase.auth.getSession();
      if (!session?.user) { setOrderError('Please sign in to place an order.'); setIsSubmitting(false); return; }

      const orderItems = items.map((item) => ({
        product_id: item.product_id,
        quantity: item.quantity,
        price: item.product.sale_price ?? item.product.base_price,
        name: item.product.name_en,
        sku: item.product.sku,
        total: (item.product.sale_price ?? item.product.base_price) * item.quantity,
      }));

      const { data, error } = await supabase.rpc('create_order_v2', {
        p_user_id: session.user.id,
        p_shipping_address: {
          full_name: shippingData.full_name, phone: shippingData.phone,
          street: shippingData.street, city: shippingData.city,
          governorate: shippingData.governorate, postal_code: shippingData.postal_code || null,
        },
        p_items: orderItems,
        p_payment_method: 'cod',
        p_shipping_fee: SHIPPING_FEE,
        p_subtotal: subtotal,
        p_total: subtotal + SHIPPING_FEE,
      });

      if (error) throw error;
      clearCart();
      setOrderNumber(data?.order_number ?? 'N/A');
      setStep(2);
    } catch (err: any) {
      setOrderError(err?.message ?? 'Failed to create order. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  if (items.length === 0 && step !== 2) {
    return (
      <div className="bg-[#f8f8f8] min-h-screen flex items-center justify-center p-8">
        <div className="w-full max-w-md bg-white border border-[#e8e8e8] rounded-lg p-8 text-center">
          <div className="w-20 h-20 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
            <ShoppingBag className="w-10 h-10 text-[#E14A5C]/40" />
          </div>
          <h1 className="font-heading font-bold text-2xl text-[#0D0625] mb-2">Your cart is empty</h1>
          <p className="text-[#777] text-sm mb-6">Add some products to your cart before checking out.</p>
          <Link
            href={ROUTES.products}
            className="inline-flex items-center gap-2 bg-[#E14A5C] hover:bg-[#c93e4e] text-white px-5 py-2.5 rounded-md font-semibold text-sm transition-colors"
          >
            Continue Shopping
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-[#f8f8f8] min-h-screen">
      <div className="container-nest py-8 max-w-3xl mx-auto">
        <h1 className="font-heading font-bold text-2xl text-[#0D0625] mb-8">Checkout</h1>

        {/* Stepper */}
        <div className="flex items-center gap-2 mb-8">
          {STEPS.map((s, i) => (
            <React.Fragment key={s.label}>
              <div className="flex items-center">
                <div className={`flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold transition-colors ${i < step ? 'bg-green-500 text-white' : i === step ? 'bg-[#E14A5C] text-white' : 'border-2 border-[#e0e0e0] text-[#ccc]'}`}>
                  {i < step ? <Check className="w-4 h-4" /> : i + 1}
                </div>
                <span className={`ml-2 text-sm font-medium hidden sm:inline ${i === step ? 'text-[#0D0625]' : i < step ? 'text-[#999]' : 'text-[#ccc]'}`}>{s.label}</span>
              </div>
              {i < STEPS.length - 1 && <div className={`flex-1 h-0.5 ${i < step ? 'bg-green-400' : 'bg-[#e8e8e8]'}`} />}
            </React.Fragment>
          ))}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-5">
            {/* Step 0: Shipping */}
            {step === 0 && (
              <div className="bg-white border border-[#e8e8e8] rounded-lg p-6">
                <h2 className="font-heading font-bold text-lg text-[#0D0625] mb-5 flex items-center gap-2">
                  <MapPin className="w-5 h-5 text-[#E14A5C]" /> Shipping Information
                </h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {[
                    { key: 'full_name', label: 'Full Name',      type: 'text', placeholder: 'Ahmed Mohamed', col: 1 },
                    { key: 'phone',     label: 'Phone',          type: 'tel',  placeholder: '01012345678',   col: 1 },
                    { key: 'street',    label: 'Street Address', type: 'text', placeholder: '123 Main Street', col: 2 },
                    { key: 'city',      label: 'City',           type: 'text', placeholder: 'Cairo',          col: 1 },
                  ].map(({ key, label, type, placeholder, col }) => (
                    <div key={key} className={col === 2 ? 'sm:col-span-2' : ''}>
                      <label className="block text-sm font-medium text-[#333] mb-1.5">{label}</label>
                      <input
                        type={type}
                        value={(shippingData as any)[key]}
                        onChange={(e) => updateField(key as keyof ShippingFormData, e.target.value)}
                        className={INPUT_CLASS} placeholder={placeholder}
                      />
                    </div>
                  ))}
                  <div>
                    <label className="block text-sm font-medium text-[#333] mb-1.5">Governorate</label>
                    <select
                      value={shippingData.governorate}
                      onChange={(e) => updateField('governorate', e.target.value)}
                      className={INPUT_CLASS}
                    >
                      <option value="">Select Governorate</option>
                      {EGYPTIAN_GOVERNORATES.map((g) => <option key={g} value={g}>{g}</option>)}
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-[#333] mb-1.5">Postal Code <span className="text-[#aaa] font-normal">(optional)</span></label>
                    <input type="text" value={shippingData.postal_code} onChange={(e) => updateField('postal_code', e.target.value)} className={INPUT_CLASS} placeholder="12345" />
                  </div>
                </div>
                <div className="mt-6 flex justify-end">
                  <button
                    onClick={() => setStep(1)} disabled={!isShippingFormValid}
                    className="bg-[#E14A5C] hover:bg-[#c93e4e] text-white px-6 py-2.5 rounded-md font-semibold text-sm disabled:opacity-50 transition-colors"
                  >
                    Continue to Review →
                  </button>
                </div>
              </div>
            )}

            {/* Step 1: Review */}
            {step === 1 && (
              <>
                <div className="bg-white border border-[#e8e8e8] rounded-lg p-6">
                  <h2 className="font-heading font-bold text-lg text-[#0D0625] mb-4 flex items-center gap-2">
                    <ClipboardList className="w-5 h-5 text-[#E14A5C]" /> Order Review
                  </h2>
                  <div className="divide-y divide-[#f5f5f5]">
                    {items.map((item) => {
                      const price = item.product.sale_price ?? item.product.base_price;
                      return (
                        <div key={item.product_id} className="flex gap-4 py-4">
                          <div className="w-16 h-16 bg-[#f8f8f8] rounded-md border border-[#e8e8e8] flex-shrink-0 overflow-hidden">
                            {item.product.images?.[0]?.url
                              ? <img src={item.product.images[0].url} alt={item.product.name_en} className="w-full h-full object-contain p-1" />
                              : <div className="w-full h-full flex items-center justify-center text-[#ccc] text-xs">No img</div>}
                          </div>
                          <div className="flex-1">
                            <h3 className="font-medium text-sm text-[#0D0625] line-clamp-2">{item.product.name_en}</h3>
                            <p className="text-sm text-[#E14A5C] font-bold mt-1">EGP {price.toLocaleString()}</p>
                            <div className="mt-2">
                              <QuantitySelector quantity={item.quantity} onIncrease={() => updateQuantity(item.product_id, item.quantity + 1)} onDecrease={() => updateQuantity(item.product_id, item.quantity - 1)} max={item.product.available_stock} />
                            </div>
                          </div>
                          <div className="text-right text-sm font-semibold text-[#0D0625]">
                            EGP {(price * item.quantity).toFixed(2)}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>

                <div className="bg-white border border-[#e8e8e8] rounded-lg p-6">
                  <h3 className="font-semibold text-[#0D0625] mb-3">Payment Method</h3>
                  <div className="flex items-center gap-3 p-3 border border-[#E14A5C]/30 rounded-md bg-[#fde8ea]">
                    <div className="w-4 h-4 rounded-full border-2 border-[#E14A5C] flex items-center justify-center">
                      <div className="w-2 h-2 rounded-full bg-[#E14A5C]" />
                    </div>
                    <span className="text-sm font-medium text-[#0D0625]">Cash on Delivery</span>
                  </div>
                </div>

                {orderError && (
                  <div className="bg-red-50 border border-red-200 rounded-md p-4 text-sm text-red-600">{orderError}</div>
                )}

                <div className="flex gap-3">
                  <button
                    onClick={() => setStep(0)}
                    className="px-5 py-2.5 border border-[#e0e0e0] text-[#555] rounded-md font-medium text-sm hover:bg-[#f8f8f8] transition-colors"
                  >
                    ← Back
                  </button>
                  <button
                    onClick={handlePlaceOrder} disabled={isSubmitting}
                    className="flex-1 bg-[#E14A5C] hover:bg-[#c93e4e] text-white px-6 py-2.5 rounded-md font-semibold text-sm disabled:opacity-50 transition-colors flex items-center justify-center gap-2"
                  >
                    {isSubmitting ? <><Loader2 className="w-4 h-4 animate-spin" /> Placing Order…</> : 'Place Order'}
                  </button>
                </div>
              </>
            )}

            {/* Step 2: Confirmation */}
            {step === 2 && (
              <div className="bg-white border border-[#e8e8e8] rounded-lg p-10 text-center">
                <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-5">
                  <Check className="w-10 h-10 text-green-600" />
                </div>
                <h2 className="font-heading font-bold text-2xl text-[#0D0625] mb-2">Order Placed!</h2>
                <p className="text-[#777] text-sm mb-4">Thank you for your order. We'll contact you to confirm delivery.</p>
                {orderNumber && (
                  <p className="text-sm font-medium text-[#555] mb-6">
                    Order Number: <span className="text-[#E14A5C] font-bold">{orderNumber}</span>
                  </p>
                )}
                <Link
                  href={ROUTES.account.orders}
                  className="inline-flex items-center gap-2 bg-[#E14A5C] hover:bg-[#c93e4e] text-white px-6 py-2.5 rounded-md font-semibold text-sm transition-colors"
                >
                  View My Orders
                </Link>
              </div>
            )}
          </div>

          {/* Order Summary Sidebar */}
          {step < 2 && (
            <div className="bg-white border border-[#e8e8e8] rounded-lg p-5 h-fit">
              <h3 className="font-heading font-semibold text-[#0D0625] mb-4">Order Summary</h3>
              <div className="space-y-2 text-sm mb-4">
                <div className="flex justify-between text-[#666]">
                  <span>Subtotal</span><span className="text-[#0D0625]">EGP {subtotal.toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-[#666]">
                  <span>Shipping</span><span className="text-[#0D0625]">EGP {SHIPPING_FEE.toFixed(2)}</span>
                </div>
              </div>
              <div className="flex justify-between border-t border-[#f0f0f0] pt-3 text-base font-bold text-[#0D0625]">
                <span>Total</span>
                <span className="text-[#E14A5C]">EGP {(subtotal + SHIPPING_FEE).toFixed(2)}</span>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
