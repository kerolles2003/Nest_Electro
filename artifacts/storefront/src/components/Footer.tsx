import { Link } from 'wouter';
import { ROUTES } from '@/lib/constants';
import { Phone, Mail, MapPin } from 'lucide-react';

export function Footer() {
  return (
    <footer className="bg-[#0D0625] text-white">
      <div className="container-nest py-12">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-10">
          {/* Brand */}
          <div className="col-span-2 md:col-span-1">
            <div className="flex flex-col leading-none mb-4">
              <span className="font-heading font-extrabold text-[22px] text-white tracking-tight leading-none">NEST</span>
              <span className="text-[9px] tracking-[0.25em] text-[#E14A5C] uppercase font-bold leading-none mt-0.5">ELECTRONICS</span>
            </div>
            <p className="text-sm text-white/50 leading-relaxed mb-5">
              Egypt's electronics store for engineers and makers. Quality components, fast delivery.
            </p>
            <div className="space-y-2 text-sm text-white/50">
              <div className="flex items-center gap-2">
                <MapPin className="w-4 h-4 text-[#E14A5C] flex-shrink-0" />
                <span>Cairo, Egypt</span>
              </div>
              <div className="flex items-center gap-2">
                <Phone className="w-4 h-4 text-[#E14A5C] flex-shrink-0" />
                <span>+20 100 000 0000</span>
              </div>
              <div className="flex items-center gap-2">
                <Mail className="w-4 h-4 text-[#E14A5C] flex-shrink-0" />
                <span>info@nestelectronics.eg</span>
              </div>
            </div>
          </div>

          {/* Shop */}
          <div>
            <h3 className="text-sm font-bold text-white mb-4 uppercase tracking-wider">Shop</h3>
            <div className="space-y-2.5">
              <Link href={ROUTES.products} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">All Products</Link>
              <Link href={ROUTES.categories} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Categories</Link>
              <Link href={`${ROUTES.products}?sort=newest`} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">New Arrivals</Link>
              <Link href={`${ROUTES.products}?sort=rating`} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Top Rated</Link>
              <Link href={`${ROUTES.products}?sale=true`} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Sale Items</Link>
            </div>
          </div>

          {/* Account */}
          <div>
            <h3 className="text-sm font-bold text-white mb-4 uppercase tracking-wider">Account</h3>
            <div className="space-y-2.5">
              <Link href={ROUTES.account.orders} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">My Orders</Link>
              <Link href={ROUTES.wishlist} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Wishlist</Link>
              <Link href={ROUTES.account.profile} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Profile</Link>
              <Link href={ROUTES.account.addresses} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Addresses</Link>
            </div>
          </div>

          {/* Support */}
          <div>
            <h3 className="text-sm font-bold text-white mb-4 uppercase tracking-wider">Support</h3>
            <div className="space-y-2.5">
              <Link href={ROUTES.contact} className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Contact Us</Link>
              <a href="#" className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">FAQ</a>
              <a href="#" className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Shipping Policy</a>
              <a href="#" className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Return Policy</a>
              <a href="#" className="block text-sm text-white/50 hover:text-[#E14A5C] transition-colors">Privacy Policy</a>
            </div>
          </div>
        </div>
      </div>

      <div className="border-t border-white/5">
        <div className="container-nest py-4 flex flex-col sm:flex-row justify-between items-center gap-2">
          <span className="text-xs text-white/30">&copy; 2025 Nest Electronics. All rights reserved.</span>
          <div className="flex items-center gap-3 text-xs text-white/30">
            <span>Cash on Delivery</span>
            <span className="text-white/15">·</span>
            <span>Shipping across Egypt</span>
            <span className="text-white/15">·</span>
            <span>100% Authentic</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
