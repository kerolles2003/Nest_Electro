import { Link, useLocation } from 'wouter';
import { Package, User, MapPin, LogOut } from 'lucide-react';
import { useAuth } from '@/hooks/useAuth';
import { ROUTES } from '@/lib/constants';

const navItems = [
  { href: ROUTES.account.orders,    label: 'Orders',    icon: Package },
  { href: ROUTES.account.profile,   label: 'Profile',   icon: User },
  { href: ROUTES.account.addresses, label: 'Addresses', icon: MapPin },
];

export default function AccountLayout({ children }: { children: React.ReactNode }) {
  const [location, navigate] = useLocation();
  const { user, signOut } = useAuth();

  const handleSignOut = async () => {
    await signOut();
    navigate(ROUTES.home);
  };

  const isActive = (href: string) => {
    if (href === ROUTES.account.orders) return location === href || location.startsWith(ROUTES.account.orders + '/');
    return location.startsWith(href);
  };

  const initials = user?.initials ?? 'U';
  const displayName = user?.fullName ?? 'User';
  const displayEmail = user?.email ?? 'Customer';

  return (
    <div className="bg-[#f8f8f8] min-h-screen">
      <div className="container-nest py-8">
        <div className="flex flex-col lg:flex-row gap-6">
          {/* Mobile Tab Nav */}
          <nav className="lg:hidden flex gap-0 border-b border-[#e8e8e8] overflow-x-auto bg-white rounded-t-md">
            {navItems.map((item) => {
              const active = isActive(item.href);
              return (
                <Link key={item.href} href={item.href}>
                  <a className={`flex items-center gap-2 px-4 py-3 text-sm font-medium whitespace-nowrap border-b-2 transition-colors ${active ? 'border-[#E14A5C] text-[#E14A5C]' : 'border-transparent text-[#666] hover:text-[#0D0625]'}`}>
                    <item.icon className="w-4 h-4" />
                    {item.label}
                  </a>
                </Link>
              );
            })}
          </nav>

          {/* Sidebar */}
          <aside className="hidden lg:block w-56 shrink-0">
            <div className="bg-white border border-[#e8e8e8] rounded-lg overflow-hidden sticky top-24">
              <div className="px-4 py-4 border-b border-[#f0f0f0] bg-[#0D0625]">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-[#E14A5C] text-white flex items-center justify-center text-base font-bold shrink-0">
                    {initials}
                  </div>
                  <div className="min-w-0">
                    <p className="text-sm font-semibold text-white truncate">{displayName}</p>
                    <p className="text-xs text-white/50 truncate">{displayEmail}</p>
                  </div>
                </div>
              </div>

              <nav className="p-2">
                {navItems.map((item) => {
                  const active = isActive(item.href);
                  return (
                    <Link key={item.href} href={item.href}>
                      <a className={`flex items-center gap-3 px-4 py-2.5 rounded text-sm transition-colors ${active ? 'bg-[#fde8ea] text-[#E14A5C] font-semibold border-r-2 border-[#E14A5C]' : 'text-[#555] hover:bg-[#f8f8f8] hover:text-[#E14A5C]'}`}>
                        <item.icon className="w-4 h-4" />
                        {item.label}
                      </a>
                    </Link>
                  );
                })}
              </nav>

              <div className="p-2 border-t border-[#f0f0f0]">
                <button
                  onClick={handleSignOut}
                  className="flex items-center gap-3 w-full px-4 py-2.5 rounded text-sm text-[#999] hover:bg-red-50 hover:text-red-500 transition-colors"
                >
                  <LogOut className="w-4 h-4" /> Sign Out
                </button>
              </div>
            </div>
          </aside>

          <main className="flex-1 min-w-0">{children}</main>
        </div>
      </div>
    </div>
  );
}
