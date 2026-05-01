import React from 'react';
import { Link } from 'wouter';
import { X, ShoppingBag, Trash2, ArrowRight, ShieldCheck, Plus, Minus } from 'lucide-react';
import { useUIStore } from '@/stores/ui-store';
import { useCartStore } from '@/stores/cart-store';

export function CartDrawer() {
  const { isCartOpen, closeCart } = useUIStore();
  const { items, removeItem, updateQuantity, getTotalPrice } = useCartStore();

  if (!isCartOpen) return null;

  const subtotal = getTotalPrice();

  return (
    <>
      <div className="fixed inset-0 bg-black/40 z-50" onClick={closeCart} />
      <div className="fixed right-0 top-0 h-full w-full max-w-sm bg-white shadow-2xl z-50 flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-slate-200">
          <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
            <ShoppingBag className="w-5 h-5" />
            Your Cart
            {items.length > 0 && (
              <span className="text-sm font-normal text-slate-500">({items.length} {items.length === 1 ? 'item' : 'items'})</span>
            )}
          </h2>
          <button onClick={closeCart} className="p-2 rounded-full hover:bg-slate-100 transition-colors">
            <X className="w-5 h-5 text-slate-500" />
          </button>
        </div>

        {/* Items */}
        <div className="flex-1 overflow-y-auto">
          {items.length === 0 ? (
            <div className="h-full flex flex-col items-center justify-center px-6 py-12">
              <div className="w-16 h-16 rounded-full bg-slate-100 flex items-center justify-center mb-4">
                <ShoppingBag className="w-8 h-8 text-slate-300" />
              </div>
              <p className="text-slate-900 font-medium text-sm">Your cart is empty</p>
              <p className="text-slate-500 text-xs mt-1 mb-6 text-center">Add items to get started</p>
              <button
                onClick={closeCart}
                className="inline-flex items-center gap-1.5 px-5 py-2.5 border border-slate-200 text-slate-700 rounded-md hover:bg-slate-50 text-sm font-medium transition-colors"
              >
                Continue Shopping <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          ) : (
            <div className="divide-y divide-slate-100">
              {items.map((item) => {
                const price = item.product.sale_price ?? item.product.base_price;
                const lineTotal = price * item.quantity;
                return (
                  <div key={item.product_id} className="flex gap-3 px-5 py-4">
                    <div className="w-16 h-16 bg-slate-50 rounded-md border border-slate-200 flex-shrink-0 overflow-hidden">
                      {item.product.images?.[0]?.url ? (
                        <img src={item.product.images[0].url} alt={item.product.name_en} className="w-full h-full object-contain p-1" />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-slate-300 text-xs">No Image</div>
                      )}
                    </div>
                    <div className="flex-1 flex flex-col justify-between min-w-0">
                      <div className="flex justify-between items-start gap-2">
                        <h3 className="text-sm font-medium text-slate-900 line-clamp-2">{item.product.name_en}</h3>
                        <button onClick={() => removeItem(item.product_id)} className="text-slate-400 hover:text-red-500 p-0.5 flex-shrink-0 transition-colors">
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      </div>
                      <p className="text-sm text-blue-600 font-semibold mt-0.5">EGP {price.toLocaleString()}</p>
                      <div className="flex items-center justify-between mt-2">
                        <div className="flex items-center border border-slate-200 rounded-md">
                          <button onClick={() => updateQuantity(item.product_id, item.quantity - 1)} disabled={item.quantity <= 1} className="px-2 py-1.5 text-slate-500 hover:bg-slate-50 disabled:opacity-40 transition-colors">
                            <Minus className="w-3.5 h-3.5" />
                          </button>
                          <span className="w-8 text-center text-sm font-medium">{item.quantity}</span>
                          <button onClick={() => updateQuantity(item.product_id, item.quantity + 1)} disabled={item.quantity >= item.product.available_stock} className="px-2 py-1.5 text-slate-500 hover:bg-slate-50 disabled:opacity-40 transition-colors">
                            <Plus className="w-3.5 h-3.5" />
                          </button>
                        </div>
                        <span className="text-sm font-semibold text-slate-900">EGP {lineTotal.toLocaleString()}</span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Footer */}
        {items.length > 0 && (
          <div className="border-t border-slate-200 px-5 py-4 space-y-3 bg-slate-50">
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-slate-500">Subtotal</span>
              <span className="text-lg font-bold text-slate-900">EGP {subtotal.toLocaleString(undefined, { minimumFractionDigits: 2 })}</span>
            </div>
            <p className="text-xs text-slate-500">Shipping and taxes calculated at checkout.</p>
            <Link href="/checkout" onClick={closeCart}>
              <button className="w-full bg-blue-600 text-white py-3 rounded-md font-semibold hover:bg-blue-700 transition-colors flex items-center justify-center gap-2">
                Proceed to Checkout <ArrowRight className="w-4 h-4" />
              </button>
            </Link>
            <div className="flex items-center justify-center gap-1.5 text-xs text-slate-500">
              <ShieldCheck className="w-3.5 h-3.5" /> Secure checkout
            </div>
          </div>
        )}
      </div>
    </>
  );
}
