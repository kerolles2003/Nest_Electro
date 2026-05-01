import { Switch, Route, Router as WouterRouter } from 'wouter';
import { Navbar } from '@/components/Navbar';
import { Footer } from '@/components/Footer';
import AccountLayout from '@/pages/account/AccountLayout';
import HomePage from '@/pages/HomePage';
import ProductsPage from '@/pages/ProductsPage';
import ProductDetailPage from '@/pages/ProductDetailPage';
import LoginPage from '@/pages/LoginPage';
import RegisterPage from '@/pages/RegisterPage';
import ForgotPasswordPage from '@/pages/ForgotPasswordPage';
import CategoryPage from '@/pages/CategoryPage';
import CategoriesPage from '@/pages/CategoriesPage';
import BrandPage from '@/pages/BrandPage';
import SearchPage from '@/pages/SearchPage';
import WishlistPage from '@/pages/WishlistPage';
import ContactPage from '@/pages/ContactPage';
import CheckoutPage from '@/pages/CheckoutPage';
import OrdersPage from '@/pages/account/OrdersPage';
import OrderDetailPage from '@/pages/account/OrderDetailPage';
import ProfilePage from '@/pages/account/ProfilePage';
import AddressesPage from '@/pages/account/AddressesPage';

const AUTH_ROUTES = ['/login', '/register', '/forgot-password'];

function isAuthRoute(path: string) {
  return AUTH_ROUTES.some((r) => path === r || path.startsWith(r + '?'));
}

function ShellLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      <main className="flex-1">{children}</main>
      <Footer />
    </div>
  );
}

function AccountPage({ children }: { children: React.ReactNode }) {
  return (
    <ShellLayout>
      <AccountLayout>{children}</AccountLayout>
    </ShellLayout>
  );
}

function Router() {
  return (
    <Switch>
      {/* Auth pages — no shell layout */}
      <Route path="/login" component={LoginPage} />
      <Route path="/register" component={RegisterPage} />
      <Route path="/forgot-password" component={ForgotPasswordPage} />

      {/* Checkout — uses shell */}
      <Route path="/checkout">
        {() => (
          <ShellLayout>
            <CheckoutPage />
          </ShellLayout>
        )}
      </Route>

      {/* Account pages */}
      <Route path="/account/orders">
        {() => <AccountPage><OrdersPage /></AccountPage>}
      </Route>
      <Route path="/account/orders/:id">
        {() => <AccountPage><OrderDetailPage /></AccountPage>}
      </Route>
      <Route path="/account/profile">
        {() => <AccountPage><ProfilePage /></AccountPage>}
      </Route>
      <Route path="/account/addresses">
        {() => <AccountPage><AddressesPage /></AccountPage>}
      </Route>

      {/* Shop pages */}
      <Route path="/products/:slug">
        {() => <ShellLayout><ProductDetailPage /></ShellLayout>}
      </Route>
      <Route path="/products">
        {() => <ShellLayout><ProductsPage /></ShellLayout>}
      </Route>
      <Route path="/categories/:slug">
        {() => <ShellLayout><CategoryPage /></ShellLayout>}
      </Route>
      <Route path="/categories">
        {() => <ShellLayout><CategoriesPage /></ShellLayout>}
      </Route>
      <Route path="/brands/:slug">
        {() => <ShellLayout><BrandPage /></ShellLayout>}
      </Route>
      <Route path="/search">
        {() => <ShellLayout><SearchPage /></ShellLayout>}
      </Route>
      <Route path="/wishlist">
        {() => <ShellLayout><WishlistPage /></ShellLayout>}
      </Route>
      <Route path="/contact">
        {() => <ShellLayout><ContactPage /></ShellLayout>}
      </Route>

      {/* Home */}
      <Route path="/">
        {() => <ShellLayout><HomePage /></ShellLayout>}
      </Route>

      {/* 404 */}
      <Route>
        {() => (
          <ShellLayout>
            <div className="container-nest py-20 text-center">
              <h1 className="text-4xl font-bold text-slate-900 mb-4">404</h1>
              <p className="text-slate-500 mb-8">The page you're looking for doesn't exist.</p>
              <a href="/" className="inline-flex items-center gap-2 bg-blue-600 text-white px-5 py-2.5 rounded-md font-medium hover:bg-blue-700 transition-colors">
                Go Home
              </a>
            </div>
          </ShellLayout>
        )}
      </Route>
    </Switch>
  );
}

export default function App() {
  return (
    <WouterRouter base={import.meta.env.BASE_URL?.replace(/\/$/, '') ?? ''}>
      <Router />
    </WouterRouter>
  );
}
