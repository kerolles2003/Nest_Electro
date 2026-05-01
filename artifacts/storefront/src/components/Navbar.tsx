import React, { useCallback, useEffect, useRef, useState } from 'react';
import { Link, useLocation } from 'wouter';
import { Search, Heart, ShoppingCart, Menu, X, User, ChevronDown, LayoutGrid, LogOut, Package, MapPin } from 'lucide-react';
import { useUIStore } from '@/stores/ui-store';
import { useCartStore } from '@/stores/cart-store';
import { useWishlistStore } from '@/stores/wishlist-store';
import { useAuth } from '@/hooks/useAuth';
import { CartDrawer } from '@/components/CartDrawer';
import { ROUTES } from '@/lib/constants';
import { getSupabaseClient } from '@/lib/supabase';

interface CategoryItem {
  id: string;
  name_en: string;
  slug: string;
  parent_id: string | null;
}

export function Navbar() {
  const [location, navigate] = useLocation();
  const { isCartOpen, isMobileMenuOpen, toggleMobileMenu, closeMobileMenu, openCart } = useUIStore();
  const totalItems = useCartStore((s) => s.getTotalItems());
  const wishlistCount = useWishlistStore((s) => s.items.length);
  const { user, signOut } = useAuth();
  const [categories, setCategories] = useState<CategoryItem[]>([]);
  const [searchValue, setSearchValue] = useState('');
  const [mobileSearchValue, setMobileSearchValue] = useState('');
  const [isProfileDropdownOpen, setIsProfileDropdownOpen] = useState(false);
  const [activeCategory, setActiveCategory] = useState<string | null>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const fetchCategories = async () => {
      const supabase = getSupabaseClient();
      const { data } = await supabase
        .from('categories')
        .select('id, name_en, slug, parent_id')
        .eq('is_active', true)
        .is('deleted_at', null)
        .order('sort_order');
      if (data) setCategories(data);
    };
    fetchCategories();
  }, []);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsProfileDropdownOpen(false);
      }
    }
    if (isProfileDropdownOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [isProfileDropdownOpen]);

  const handleSignOut = async () => {
    await signOut();
    setIsProfileDropdownOpen(false);
    navigate(ROUTES.home);
  };

  const handleSearch = useCallback(() => {
    const q = searchValue.trim();
    if (q) navigate(`${ROUTES.search}?q=${encodeURIComponent(q)}`);
  }, [searchValue, navigate]);

  const handleMobileSearch = useCallback(() => {
    const q = mobileSearchValue.trim();
    if (q) {
      navigate(`${ROUTES.search}?q=${encodeURIComponent(q)}`);
      closeMobileMenu();
      setMobileSearchValue('');
    }
  }, [mobileSearchValue, navigate, closeMobileMenu]);

  const rootCategories = categories.filter((c) => !c.parent_id);
  const getSubcategories = (parentId: string) => categories.filter((c) => c.parent_id === parentId);

  return (
    <>
      {/* Top Bar */}
      <div className="hidden md:block bg-foreground text-white h-9">
        <div className="container-nest h-full flex items-center justify-between">
          <span className="text-xs">🇪🇬 Free delivery on orders over 500 EGP within Cairo</span>
          <div className="flex items-center gap-4 text-xs">
            {user ? (
              <button onClick={() => setIsProfileDropdownOpen(!isProfileDropdownOpen)} className="hover:opacity-80 transition-opacity">
                {user.fullName}
              </button>
            ) : (
              <>
                <Link href={ROUTES.login} className="hover:opacity-80 transition-opacity">Login</Link>
                <span className="text-white/30">|</span>
                <Link href={ROUTES.register} className="hover:opacity-80 transition-opacity">Register</Link>
              </>
            )}
          </div>
        </div>
      </div>

      {/* Main Header */}
      <header className="bg-white border-b border-slate-200 shadow-sm sticky top-0 z-50">
        <div className="container-nest h-[68px] flex items-center justify-between gap-4">
          {/* Logo */}
          <Link href={ROUTES.home} className="flex-shrink-0 flex flex-col leading-none">
            <span className="font-heading font-bold text-xl text-slate-900 tracking-tight">NEST</span>
            <span className="text-[10px] tracking-[0.2em] text-blue-600 uppercase font-semibold">ELECTRONICS</span>
          </Link>

          {/* Search Bar */}
          <div className="hidden lg:flex flex-1 max-w-xl mx-auto">
            <div className="relative w-full flex items-center">
              <input
                type="text"
                placeholder="Search for products..."
                value={searchValue}
                onChange={(e) => setSearchValue(e.target.value)}
                onKeyDown={(e) => { if (e.key === 'Enter') handleSearch(); }}
                className="h-10 w-full border border-slate-200 rounded-l-md px-4 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-200 focus:border-blue-500 transition-colors"
              />
              <button
                className="h-10 px-5 bg-blue-600 hover:bg-blue-700 text-white rounded-r-md text-sm font-medium transition-colors flex items-center gap-1.5"
                onClick={handleSearch}
              >
                <Search className="w-4 h-4" />
                <span className="hidden sm:inline">Search</span>
              </button>
            </div>
          </div>

          {/* Icons */}
          <div className="flex items-center gap-2">
            <Link href={ROUTES.wishlist} className="relative p-2 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded-md transition-colors" aria-label="Wishlist">
              <Heart className="w-5 h-5" />
              {wishlistCount > 0 && (
                <span className="absolute -top-0.5 -right-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-blue-600 text-white text-[10px] font-bold">
                  {wishlistCount}
                </span>
              )}
            </Link>

            <button onClick={openCart} className="relative p-2 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded-md transition-colors" aria-label="Cart">
              <ShoppingCart className="w-5 h-5" />
              {totalItems > 0 && (
                <span className="absolute -top-0.5 -right-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-blue-600 text-white text-[10px] font-bold">
                  {totalItems}
                </span>
              )}
            </button>

            {user ? (
              <div className="relative hidden md:block" ref={dropdownRef}>
                <button
                  onClick={() => setIsProfileDropdownOpen(!isProfileDropdownOpen)}
                  className="flex items-center gap-2 p-2 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded-md transition-colors"
                >
                  <div className="w-7 h-7 rounded-full bg-blue-100 flex items-center justify-center text-[11px] font-bold text-blue-600">
                    {user.initials}
                  </div>
                  <ChevronDown className="w-3.5 h-3.5" />
                </button>
                {isProfileDropdownOpen && (
                  <div className="absolute right-0 top-full mt-1 w-56 bg-white rounded-lg shadow-dropdown border border-slate-200 py-2 z-50">
                    <div className="px-4 py-3 border-b border-slate-100">
                      <p className="text-sm font-semibold text-slate-900 truncate">{user.fullName}</p>
                      <p className="text-xs text-slate-500 truncate">{user.email}</p>
                    </div>
                    <Link href={ROUTES.account.orders} onClick={() => setIsProfileDropdownOpen(false)} className="flex items-center gap-3 px-4 py-2.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 transition-colors">
                      <Package className="w-4 h-4" /> My Orders
                    </Link>
                    <Link href={ROUTES.account.profile} onClick={() => setIsProfileDropdownOpen(false)} className="flex items-center gap-3 px-4 py-2.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 transition-colors">
                      <User className="w-4 h-4" /> My Profile
                    </Link>
                    <Link href={ROUTES.account.addresses} onClick={() => setIsProfileDropdownOpen(false)} className="flex items-center gap-3 px-4 py-2.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 transition-colors">
                      <MapPin className="w-4 h-4" /> My Addresses
                    </Link>
                    <div className="border-t border-slate-100 mt-1 pt-1">
                      <button onClick={handleSignOut} className="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 transition-colors">
                        <LogOut className="w-4 h-4" /> Sign Out
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <Link href={ROUTES.login} className="hidden md:flex items-center gap-2 p-2 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded-md transition-colors">
                <User className="w-5 h-5" />
              </Link>
            )}

            <button className="lg:hidden p-2 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded-md transition-colors" onClick={toggleMobileMenu}>
              <Menu className="w-5 h-5" />
            </button>
          </div>
        </div>
      </header>

      {/* Category Nav */}
      <nav className="hidden lg:block bg-slate-50 border-b border-slate-200">
        <div className="container-nest h-[44px] flex items-center gap-1 overflow-x-auto scrollbar-none">
          <Link
            href={ROUTES.products}
            className={`flex items-center gap-1.5 px-3 py-2 text-sm font-medium whitespace-nowrap transition-colors rounded-md ${location === '/products' ? 'text-blue-600 bg-blue-50' : 'text-slate-500 hover:text-blue-600 hover:bg-slate-100'}`}
          >
            <LayoutGrid className="w-4 h-4" />
            All Products
          </Link>
          {rootCategories.map((cat) => {
            const subs = getSubcategories(cat.id);
            return (
              <div
                key={cat.id}
                className="relative group"
                onMouseEnter={() => setActiveCategory(cat.id)}
                onMouseLeave={() => setActiveCategory(null)}
              >
                <Link
                  href={`/categories/${cat.slug}`}
                  className={`flex items-center gap-1 px-3 py-2 text-sm font-medium whitespace-nowrap transition-colors rounded-md ${location === `/categories/${cat.slug}` ? 'text-blue-600' : 'text-slate-500 hover:text-blue-600 hover:bg-slate-100'}`}
                >
                  {cat.name_en}
                  {subs.length > 0 && <ChevronDown className="w-3 h-3 opacity-60" />}
                </Link>
                {subs.length > 0 && activeCategory === cat.id && (
                  <div className="absolute top-full left-0 min-w-[400px] bg-white border border-slate-200 shadow-dropdown z-40 p-4 rounded-b-md">
                    <div className="grid grid-cols-3 gap-2">
                      {subs.map((sub) => (
                        <Link key={sub.id} href={`/categories/${sub.slug}`} className="text-sm text-slate-500 hover:text-blue-600 px-3 py-2 rounded-md hover:bg-slate-50 transition-colors">
                          {sub.name_en}
                        </Link>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </nav>

      {/* Mobile Menu */}
      {isMobileMenuOpen && (
        <div className="fixed inset-0 z-50 lg:hidden flex">
          <div className="fixed inset-0 bg-black/50" onClick={closeMobileMenu} />
          <div className="relative w-full max-w-xs bg-white h-full shadow-2xl overflow-y-auto flex flex-col">
            <div className="flex items-center justify-between p-4 border-b border-slate-200">
              <div className="flex flex-col leading-none">
                <span className="font-heading font-bold text-xl text-slate-900">NEST</span>
                <span className="text-[10px] tracking-[0.2em] text-blue-600 uppercase font-semibold">ELECTRONICS</span>
              </div>
              <button onClick={closeMobileMenu} className="p-2 text-slate-500 hover:bg-slate-100 rounded-md">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-4 border-b border-slate-200">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 pointer-events-none" />
                <input
                  type="text"
                  placeholder="Search products..."
                  value={mobileSearchValue}
                  onChange={(e) => setMobileSearchValue(e.target.value)}
                  onKeyDown={(e) => { if (e.key === 'Enter') handleMobileSearch(); }}
                  className="w-full h-10 pl-9 pr-4 text-sm bg-slate-50 border border-slate-200 rounded-md focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-200"
                />
              </div>
            </div>

            <nav className="flex flex-col py-2 flex-1">
              <Link href={ROUTES.products} onClick={closeMobileMenu} className="flex items-center gap-2 px-5 py-3 text-sm font-medium text-slate-700 hover:bg-slate-50">
                <LayoutGrid className="w-4 h-4" /> All Products
              </Link>
              {rootCategories.map((cat) => (
                <Link key={cat.id} href={`/categories/${cat.slug}`} onClick={closeMobileMenu} className="px-5 py-3 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50">
                  {cat.name_en}
                </Link>
              ))}
            </nav>

            <div className="border-t border-slate-200 p-4 space-y-1">
              <Link href={ROUTES.wishlist} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 rounded-md">
                <Heart className="w-4 h-4" /> Wishlist
              </Link>
              {user ? (
                <>
                  <Link href={ROUTES.account.orders} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 rounded-md">
                    <Package className="w-4 h-4" /> My Orders
                  </Link>
                  <Link href={ROUTES.account.profile} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 rounded-md">
                    <User className="w-4 h-4" /> My Profile
                  </Link>
                  <button onClick={handleSignOut} className="flex items-center gap-3 w-full px-3 py-2.5 text-sm text-red-500 hover:bg-red-50 rounded-md">
                    <LogOut className="w-4 h-4" /> Sign Out
                  </button>
                </>
              ) : (
                <Link href={ROUTES.login} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 rounded-md">
                  <User className="w-4 h-4" /> Login / Register
                </Link>
              )}
            </div>
          </div>
        </div>
      )}

      <CartDrawer />
    </>
  );
}
