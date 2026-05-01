import { Link } from 'wouter';
import { ROUTES } from '@/lib/constants';

export function Footer() {
  return (
    <footer className="bg-slate-900 text-white">
      <div className="container-nest py-12">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-10">
          <div>
            <div className="flex flex-col leading-none mb-4">
              <span className="font-heading font-bold text-xl text-white tracking-tight">NEST</span>
              <span className="text-[10px] tracking-[0.2em] text-blue-400 uppercase font-semibold">ELECTRONICS</span>
            </div>
            <p className="text-sm text-white/60 leading-relaxed mb-4">
              Egypt's electronics store for engineers and makers. Quality components with fast delivery.
            </p>
            <p className="text-sm text-white/60">Cairo, Egypt</p>
          </div>

          <div>
            <h3 className="text-sm font-semibold text-white mb-4">Shop</h3>
            <div className="space-y-2.5">
              <Link href={ROUTES.products} className="block text-sm text-white/60 hover:text-white transition-colors">Products</Link>
              <Link href={ROUTES.categories} className="block text-sm text-white/60 hover:text-white transition-colors">Categories</Link>
              <Link href={ROUTES.products} className="block text-sm text-white/60 hover:text-white transition-colors">New Arrivals</Link>
              <Link href={ROUTES.products} className="block text-sm text-white/60 hover:text-white transition-colors">Featured</Link>
            </div>
          </div>

          <div>
            <h3 className="text-sm font-semibold text-white mb-4">Account</h3>
            <div className="space-y-2.5">
              <Link href={ROUTES.account.orders} className="block text-sm text-white/60 hover:text-white transition-colors">My Orders</Link>
              <Link href={ROUTES.wishlist} className="block text-sm text-white/60 hover:text-white transition-colors">Wishlist</Link>
              <Link href={ROUTES.account.profile} className="block text-sm text-white/60 hover:text-white transition-colors">Profile</Link>
              <Link href={ROUTES.account.addresses} className="block text-sm text-white/60 hover:text-white transition-colors">Addresses</Link>
            </div>
          </div>

          <div>
            <h3 className="text-sm font-semibold text-white mb-4">Support</h3>
            <div className="space-y-2.5">
              <Link href={ROUTES.contact} className="block text-sm text-white/60 hover:text-white transition-colors">Contact Us</Link>
              <a href="#" className="block text-sm text-white/60 hover:text-white transition-colors">FAQ</a>
              <a href="#" className="block text-sm text-white/60 hover:text-white transition-colors">Shipping Policy</a>
              <a href="#" className="block text-sm text-white/60 hover:text-white transition-colors">Return Policy</a>
            </div>
          </div>
        </div>
      </div>

      <div className="border-t border-white/10">
        <div className="container-nest py-4 flex flex-col sm:flex-row justify-between items-center gap-2">
          <span className="text-xs text-white/50">&copy; 2025 Nest Electronics. All rights reserved.</span>
          <span className="text-xs text-white/50">Cash on Delivery &middot; Shipping across Egypt</span>
        </div>
      </div>
    </footer>
  );
}
