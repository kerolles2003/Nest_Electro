import { Link, useLocation } from 'wouter';
import { Package, User, MapPin, LogOut } from 'lucide-react';
import { useAuth } from '@/hooks/useAuth';
import { ROUTES } from '@/lib/constants';

const navItems = [
  { href: ROUTES.account.orders, label: 'Orders', icon: Package },
  { href: ROUTES.account.profile, label: 'Profile', icon: User },
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
    <div className="container-nest py-8">
      <div className="flex flex-col lg:flex-row gap-6">
        {/* Mobile Tab Nav */}
        <nav className="lg:hidden flex gap-1 border-b border-slate-200 overflow-x-auto pb-1">
          {navItems.map((item) => {
            const active = isActive(item.href);
            return (
              <Link key={item.href} href={item.href}>
                <a className={`flex items-center gap-2 px-4 py-2.5 text-sm font-medium whitespace-nowrap border-b-2 transition-colors ${active ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700'}`}>
                  <item.icon className="w-4 h-4" />
                  {item.label}
                </a>
              </Link>
            );
          })}
        </nav>

        {/* Sidebar */}
        <aside className="hidden lg:block w-56 shrink-0">
          <div className="bg-white border border-slate-200 rounded-md overflow-hidden sticky top-24">
            <div className="px-4 py-4 border-b border-slate-200">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center text-lg font-bold shrink-0">
                  {initials}
                </div>
                <div className="min-w-0">
                  <p className="text-sm font-medium text-slate-900 truncate">{displayName}</p>
                  <p className="text-xs text-slate-400 truncate">{displayEmail}</p>
                </div>
              </div>
            </div>
            <nav className="p-2">
              {navItems.map((item) => {
                const active = isActive(item.href);
                return (
                  <Link key={item.href} href={item.href}>
                    <a className={`flex items-center gap-3 px-4 py-2.5 rounded text-sm transition-colors ${active ? 'bg-blue-50 text-blue-600 font-medium border-r-2 border-blue-600' : 'text-slate-500 hover:bg-slate-50 hover:text-blue-600'}`}>
                      <item.icon className="w-4 h-4" />
                      {item.label}
                    </a>
                  </Link>
                );
              })}
            </nav>
            <div className="p-2 border-t border-slate-200">
              <button onClick={handleSignOut} className="flex items-center gap-3 w-full px-4 py-2.5 rounded text-sm text-slate-500 hover:bg-slate-50 hover:text-red-500 transition-colors">
                <LogOut className="w-4 h-4" /> Sign Out
              </button>
            </div>
          </div>
        </aside>

        <main className="flex-1 min-w-0">{children}</main>
      </div>
    </div>
  );
}
