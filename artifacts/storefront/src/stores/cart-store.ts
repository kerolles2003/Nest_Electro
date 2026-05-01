import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export interface CartProduct {
  id: string;
  name_en: string;
  slug: string;
  sku: string;
  base_price: number;
  sale_price: number | null;
  images: { url: string }[];
  available_stock: number;
}

export interface CartItem {
  product_id: string;
  quantity: number;
  product: CartProduct;
}

interface CartStore {
  items: CartItem[];
  isOpen: boolean;
  addItem: (product: CartProduct, quantity?: number) => void;
  removeItem: (productId: string) => void;
  updateQuantity: (productId: string, quantity: number) => void;
  clearCart: () => void;
  openCart: () => void;
  closeCart: () => void;
  toggleCart: () => void;
  getTotalItems: () => number;
  getTotalPrice: () => number;
}

export const useCartStore = create<CartStore>()(
  persist(
    (set, get) => ({
      items: [],
      isOpen: false,

      addItem: (product, quantity = 1) => {
        set((state) => {
          const existing = state.items.find((i) => i.product_id === product.id);
          if (existing) {
            return {
              items: state.items.map((i) =>
                i.product_id === product.id
                  ? { ...i, quantity: Math.min(i.quantity + quantity, product.available_stock, 99) }
                  : i
              ),
            };
          }
          return {
            items: [
              ...state.items,
              { product_id: product.id, quantity: Math.min(quantity, product.available_stock, 99), product },
            ],
          };
        });
      },

      removeItem: (productId) => {
        set((state) => ({ items: state.items.filter((i) => i.product_id !== productId) }));
      },

      updateQuantity: (productId, quantity) => {
        if (quantity <= 0) {
          get().removeItem(productId);
          return;
        }
        set((state) => ({
          items: state.items.map((i) =>
            i.product_id === productId ? { ...i, quantity: Math.min(quantity, 99) } : i
          ),
        }));
      },

      clearCart: () => set({ items: [] }),
      openCart: () => set({ isOpen: true }),
      closeCart: () => set({ isOpen: false }),
      toggleCart: () => set((state) => ({ isOpen: !state.isOpen })),

      getTotalItems: () => get().items.reduce((sum, i) => sum + i.quantity, 0),
      getTotalPrice: () =>
        get().items.reduce(
          (sum, i) => sum + (i.product.sale_price ?? i.product.base_price) * i.quantity,
          0
        ),
    }),
    {
      name: 'nest-cart',
      partialize: (state) => ({ items: state.items }),
    }
  )
);
