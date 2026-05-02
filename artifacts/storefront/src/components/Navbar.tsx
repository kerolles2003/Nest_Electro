import React, { useCallback, useEffect, useRef, useState } from 'react';
import { Link, useLocation } from 'wouter';
import {
  Search, Heart, ShoppingCart, Menu, X, User, ChevronDown,
  LogOut, Package, MapPin, Phone, AlignJustify,
} from 'lucide-react';
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
  const [isDeptMenuOpen, setIsDeptMenuOpen] = useState(false);
  const [activeCategory, setActiveCategory] = useState<string | null>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const deptRef = useRef<HTMLDivElement>(null);

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
      if (deptRef.current && !deptRef.current.contains(event.target as Node)) {
        setIsDeptMenuOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

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
      {/* ── Tier 1: Utility bar ────────────────────────────────────────── */}
      <div className="hidden md:block bg-[#0D0625] text-white">
        <div className="container-nest h-8 flex items-center justify-between">
          <span className="text-[11px] text-white/60">
            🇪🇬 Free delivery on orders over 500 EGP within Cairo
          </span>
          <div className="flex items-center gap-4 text-[11px] text-white/60">
            <Link href={ROUTES.contact} className="hover:text-white transition-colors">Store Locator</Link>
            <span className="text-white/20">|</span>
            <Link href={ROUTES.account.orders} className="hover:text-white transition-colors">Track Order</Link>
            <span className="text-white/20">|</span>
            {user ? (
              <button onClick={() => setIsProfileDropdownOpen(!isProfileDropdownOpen)} className="hover:text-white transition-colors">
                {user.fullName}
              </button>
            ) : (
              <>
                <Link href={ROUTES.login} className="hover:text-white transition-colors">Login</Link>
                <span className="text-white/20">|</span>
                <Link href={ROUTES.register} className="hover:text-white transition-colors">Register</Link>
              </>
            )}
          </div>
        </div>
      </div>

      {/* ── Tier 2: Main header ───────────────────────────────────────── */}
      <header className="bg-white border-b border-[#e8e8e8] sticky top-0 z-50 shadow-sm">
        <div className="container-nest h-[72px] flex items-center gap-5">
          {/* Logo */}
          <Link href={ROUTES.home} className="flex-shrink-0 flex flex-col leading-none mr-2">
            <span className="font-heading font-extrabold text-[20px] text-[#0D0625] tracking-tight leading-none">NEST</span>
            <span className="text-[9px] tracking-[0.25em] text-[#E14A5C] uppercase font-bold leading-none mt-0.5">ELECTRONICS</span>
          </Link>

          {/* Search bar */}
          <div className="hidden lg:flex flex-1 max-w-2xl">
            <div className="flex w-full border border-[#e8e8e8] rounded-md overflow-hidden focus-within:border-[#E14A5C] focus-within:ring-2 focus-within:ring-[#E14A5C]/10 transition-all">
              <input
                type="text"
                placeholder="Search products, brands, categories…"
                value={searchValue}
                onChange={(e) => setSearchValue(e.target.value)}
                onKeyDown={(e) => { if (e.key === 'Enter') handleSearch(); }}
                className="flex-1 h-10 px-4 text-sm bg-white focus:outline-none text-[#0D0625] placeholder:text-[#aaa]"
              />
              <button
                onClick={handleSearch}
                className="h-10 px-5 bg-[#E14A5C] hover:bg-[#c93e4e] text-white text-sm font-semibold flex items-center gap-1.5 transition-colors flex-shrink-0"
                aria-label="Search"
              >
                <Search className="w-4 h-4" />
                <span>Search</span>
              </button>
            </div>
          </div>

          {/* Right: phone + actions */}
          <div className="flex items-center gap-1 ml-auto">
            {/* Phone */}
            <div className="hidden xl:flex items-center gap-2 mr-3 text-[#0D0625]">
              <div className="w-8 h-8 rounded-full bg-[#fde8ea] flex items-center justify-center">
                <Phone className="w-3.5 h-3.5 text-[#E14A5C]" />
              </div>
              <div>
                <p className="text-[10px] text-[#999] leading-none">Call us</p>
                <p className="text-[13px] font-semibold leading-tight">+20 100 000 0000</p>
              </div>
            </div>

            {/* Wishlist */}
            <Link
              href={ROUTES.wishlist}
              className="relative flex flex-col items-center gap-0.5 px-2 py-1 text-[#555] hover:text-[#E14A5C] transition-colors"
              aria-label="Wishlist"
            >
              <Heart className="w-5 h-5" />
              {wishlistCount > 0 && (
                <span className="absolute -top-0.5 right-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-[#E14A5C] text-white text-[9px] font-bold">
                  {wishlistCount}
                </span>
              )}
              <span className="text-[10px] hidden sm:block">Wishlist</span>
            </Link>

            {/* Cart */}
            <button
              onClick={openCart}
              className="relative flex flex-col items-center gap-0.5 px-2 py-1 text-[#555] hover:text-[#E14A5C] transition-colors"
              aria-label="Cart"
            >
              <ShoppingCart className="w-5 h-5" />
              {totalItems > 0 && (
                <span className="absolute -top-0.5 right-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-[#E14A5C] text-white text-[9px] font-bold">
                  {totalItems}
                </span>
              )}
              <span className="text-[10px] hidden sm:block">Cart</span>
            </button>

            {/* Account (desktop) */}
            {user ? (
              <div className="relative hidden md:block" ref={dropdownRef}>
                <button
                  onClick={() => setIsProfileDropdownOpen(!isProfileDropdownOpen)}
                  className="flex flex-col items-center gap-0.5 px-2 py-1 text-[#555] hover:text-[#E14A5C] transition-colors"
                  aria-expanded={isProfileDropdownOpen}
                >
                  <div className="w-5 h-5 rounded-full bg-[#fde8ea] flex items-center justify-center text-[9px] font-bold text-[#E14A5C]">
                    {user.initials}
                  </div>
                  <span className="text-[10px] hidden sm:block">Account</span>
                </button>
                {isProfileDropdownOpen && (
                  <div className="absolute right-0 top-full mt-1 w-56 bg-white rounded-md shadow-dropdown border border-[#e8e8e8] py-2 z-50">
                    <div className="px-4 py-3 border-b border-[#f0f0f0]">
                      <p className="text-sm font-semibold text-[#0D0625] truncate">{user.fullName}</p>
                      <p className="text-xs text-[#999] truncate">{user.email}</p>
                    </div>
                    <Link href={ROUTES.account.orders} onClick={() => setIsProfileDropdownOpen(false)} className="flex items-center gap-3 px-4 py-2.5 text-sm text-[#555] hover:text-[#E14A5C] hover:bg-[#fdf5f5] transition-colors">
                      <Package className="w-4 h-4" /> My Orders
                    </Link>
                    <Link href={ROUTES.account.profile} onClick={() => setIsProfileDropdownOpen(false)} className="flex items-center gap-3 px-4 py-2.5 text-sm text-[#555] hover:text-[#E14A5C] hover:bg-[#fdf5f5] transition-colors">
                      <User className="w-4 h-4" /> My Profile
                    </Link>
                    <Link href={ROUTES.account.addresses} onClick={() => setIsProfileDropdownOpen(false)} className="flex items-center gap-3 px-4 py-2.5 text-sm text-[#555] hover:text-[#E14A5C] hover:bg-[#fdf5f5] transition-colors">
                      <MapPin className="w-4 h-4" /> My Addresses
                    </Link>
                    <div className="border-t border-[#f0f0f0] mt-1 pt-1">
                      <button onClick={handleSignOut} className="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 transition-colors">
                        <LogOut className="w-4 h-4" /> Sign Out
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <Link
                href={ROUTES.login}
                className="hidden md:flex flex-col items-center gap-0.5 px-2 py-1 text-[#555] hover:text-[#E14A5C] transition-colors"
              >
                <User className="w-5 h-5" />
                <span className="text-[10px] hidden sm:block">Account</span>
              </Link>
            )}

            {/* Mobile menu toggle */}
            <button
              className="lg:hidden p-2 text-[#555] hover:text-[#0D0625] ml-1"
              onClick={toggleMobileMenu}
              aria-label="Menu"
            >
              <Menu className="w-5 h-5" />
            </button>
          </div>
        </div>
      </header>

      {/* ── Tier 3: Category nav (red) ────────────────────────────────── */}
      <nav className="hidden lg:block bg-[#E14A5C] relative z-40">
        <div className="container-nest h-[42px] flex items-center">
          {/* All Departments */}
          <div className="relative flex-shrink-0" ref={deptRef}>
            <button
              onClick={() => setIsDeptMenuOpen(!isDeptMenuOpen)}
              className="flex items-center gap-2 h-[42px] px-4 bg-[#c93e4e] text-white text-sm font-semibold hover:bg-[#b83549] transition-colors"
            >
              <AlignJustify className="w-4 h-4" />
              <span>All Departments</span>
              <ChevronDown className={`w-3.5 h-3.5 transition-transform duration-200 ${isDeptMenuOpen ? 'rotate-180' : ''}`} />
            </button>
            {isDeptMenuOpen && (
              <div className="absolute top-full left-0 min-w-[240px] bg-white shadow-dropdown border border-[#e8e8e8] z-50 py-1 rounded-b-md">
                {rootCategories.map((cat) => (
                  <Link
                    key={cat.id}
                    href={`/categories/${cat.slug}`}
                    onClick={() => setIsDeptMenuOpen(false)}
                    className="flex items-center justify-between px-4 py-2.5 text-sm text-[#333] hover:bg-[#fde8ea] hover:text-[#E14A5C] transition-colors"
                  >
                    {cat.name_en}
                    {getSubcategories(cat.id).length > 0 && <ChevronDown className="w-3 h-3 -rotate-90 opacity-40" />}
                  </Link>
                ))}
              </div>
            )}
          </div>

          {/* Flat category links */}
          <div className="flex items-center overflow-x-auto scrollbar-none flex-1 px-1">
            <Link
              href={ROUTES.products}
              className={`flex-shrink-0 px-3 py-1.5 text-sm font-medium text-white/90 hover:text-white hover:bg-[#c93e4e] rounded transition-colors ${location === '/products' ? 'text-white bg-[#c93e4e]' : ''}`}
            >
              New Arrivals
            </Link>
            {rootCategories.slice(0, 7).map((cat) => {
              const subs = getSubcategories(cat.id);
              return (
                <div
                  key={cat.id}
                  className="relative group flex-shrink-0"
                  onMouseEnter={() => setActiveCategory(cat.id)}
                  onMouseLeave={() => setActiveCategory(null)}
                >
                  <Link
                    href={`/categories/${cat.slug}`}
                    className={`flex items-center gap-0.5 px-3 py-1.5 text-sm font-medium text-white/90 hover:text-white hover:bg-[#c93e4e] rounded transition-colors ${location === `/categories/${cat.slug}` ? 'text-white bg-[#c93e4e]' : ''}`}
                  >
                    {cat.name_en}
                    {subs.length > 0 && <ChevronDown className="w-3 h-3 opacity-70" />}
                  </Link>
                  {subs.length > 0 && activeCategory === cat.id && (
                    <div className="absolute top-full left-0 min-w-[220px] bg-white border border-[#e8e8e8] shadow-dropdown z-50 py-1 rounded-b-md">
                      {subs.map((sub) => (
                        <Link
                          key={sub.id}
                          href={`/categories/${sub.slug}`}
                          className="block px-4 py-2.5 text-sm text-[#333] hover:bg-[#fde8ea] hover:text-[#E14A5C] transition-colors"
                        >
                          {sub.name_en}
                        </Link>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </nav>

      {/* ── Mobile drawer ────────────────────────────────────────────── */}
      {isMobileMenuOpen && (
        <div className="fixed inset-0 z-50 lg:hidden flex">
          <div className="fixed inset-0 bg-black/50" onClick={closeMobileMenu} />
          <div className="relative w-full max-w-xs bg-white h-full shadow-2xl overflow-y-auto flex flex-col">
            <div className="flex items-center justify-between p-4 border-b border-[#e8e8e8] bg-[#0D0625]">
              <div className="flex flex-col leading-none">
                <span className="font-heading font-extrabold text-[18px] text-white tracking-tight leading-none">NEST</span>
                <span className="text-[9px] tracking-[0.25em] text-[#E14A5C] uppercase font-bold leading-none mt-0.5">ELECTRONICS</span>
              </div>
              <button onClick={closeMobileMenu} className="p-2 text-white/70 hover:text-white">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-3 border-b border-[#e8e8e8] bg-[#f8f8f8]">
              <div className="flex gap-2">
                <input
                  type="text"
                  placeholder="Search products…"
                  value={mobileSearchValue}
                  onChange={(e) => setMobileSearchValue(e.target.value)}
                  onKeyDown={(e) => { if (e.key === 'Enter') handleMobileSearch(); }}
                  className="flex-1 h-9 px-3 text-sm bg-white border border-[#e8e8e8] rounded-l-md focus:outline-none focus:border-[#E14A5C]"
                />
                <button
                  onClick={handleMobileSearch}
                  className="h-9 px-3 bg-[#E14A5C] text-white rounded-r-md"
                >
                  <Search className="w-4 h-4" />
                </button>
              </div>
            </div>

            <nav className="flex flex-col py-2 flex-1">
              <p className="px-4 pt-3 pb-1 text-[10px] font-bold text-[#999] uppercase tracking-wider">Categories</p>
              <Link href={ROUTES.products} onClick={closeMobileMenu} className="px-4 py-2.5 text-sm font-medium text-[#0D0625] hover:bg-[#fde8ea] hover:text-[#E14A5C] transition-colors">
                All Products
              </Link>
              {rootCategories.map((cat) => (
                <Link key={cat.id} href={`/categories/${cat.slug}`} onClick={closeMobileMenu} className="px-4 py-2.5 text-sm text-[#444] hover:bg-[#fde8ea] hover:text-[#E14A5C] transition-colors">
                  {cat.name_en}
                </Link>
              ))}
            </nav>

            <div className="border-t border-[#e8e8e8] p-3 space-y-1">
              <Link href={ROUTES.wishlist} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-[#444] hover:bg-[#fde8ea] hover:text-[#E14A5C] rounded-md transition-colors">
                <Heart className="w-4 h-4" /> Wishlist {wishlistCount > 0 && <span className="ml-auto text-[10px] font-bold bg-[#E14A5C] text-white rounded-full w-4 h-4 flex items-center justify-center">{wishlistCount}</span>}
              </Link>
              {user ? (
                <>
                  <Link href={ROUTES.account.orders} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-[#444] hover:bg-[#fde8ea] hover:text-[#E14A5C] rounded-md transition-colors">
                    <Package className="w-4 h-4" /> My Orders
                  </Link>
                  <Link href={ROUTES.account.profile} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-[#444] hover:bg-[#fde8ea] hover:text-[#E14A5C] rounded-md transition-colors">
                    <User className="w-4 h-4" /> My Profile
                  </Link>
                  <button onClick={handleSignOut} className="flex items-center gap-3 w-full px-3 py-2.5 text-sm text-red-500 hover:bg-red-50 rounded-md">
                    <LogOut className="w-4 h-4" /> Sign Out
                  </button>
                </>
              ) : (
                <Link href={ROUTES.login} onClick={closeMobileMenu} className="flex items-center gap-3 px-3 py-2.5 text-sm text-[#444] hover:bg-[#fde8ea] hover:text-[#E14A5C] rounded-md transition-colors">
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
