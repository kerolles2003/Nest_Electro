import { useState } from 'react';
import { Link, useLocation } from 'wouter';
import { Eye, EyeOff, CheckCircle, Shield, Truck } from 'lucide-react';
import { createBrowserClient } from '@supabase/ssr';
import { useCartStore } from '@/stores/cart-store';
import { ROUTES } from '@/lib/constants';

export default function LoginPage() {
  const [, navigate] = useLocation();
  const params = new URLSearchParams(window.location.search.slice(1));
  const redirectTo = params.get('redirect') ?? ROUTES.account.orders;

  const cartItems = useCartStore((s) => s.items);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const supabase = createBrowserClient(
    import.meta.env.VITE_SUPABASE_URL!,
    import.meta.env.VITE_SUPABASE_ANON_KEY!
  );

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (!email || !password) { setError('Please fill in all fields.'); return; }
    setLoading(true);
    const { error: authError } = await supabase.auth.signInWithPassword({ email, password });
    if (authError) { setError(authError.message); setLoading(false); return; }
    navigate(redirectTo);
  };

  const handleGoogleLogin = async () => {
    await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: `${window.location.origin}${redirectTo}` },
    });
  };

  const trustPoints = [
    { icon: CheckCircle, text: 'Genuine electronics & accessories' },
    { icon: Shield,       text: 'Secure checkout & buyer protection' },
    { icon: Truck,        text: 'Fast delivery across Egypt' },
  ];

  return (
    <div className="min-h-screen grid grid-cols-1 lg:grid-cols-2">
      {/* Left panel */}
      <div className="hidden lg:flex flex-col justify-center items-center bg-[#0D0625] p-12 text-white relative overflow-hidden">
        {/* Decorative circles */}
        <div className="absolute -top-20 -left-20 w-72 h-72 rounded-full bg-[#E14A5C] opacity-5" />
        <div className="absolute bottom-10 right-10 w-48 h-48 rounded-full bg-[#E14A5C] opacity-5" />

        <div className="relative max-w-md text-center space-y-8">
          <div>
            <p className="text-[11px] font-bold uppercase tracking-widest text-[#E14A5C] mb-2">Welcome to</p>
            <h2 className="font-heading font-extrabold text-5xl tracking-tight text-white">NEST</h2>
            <p className="text-white/40 mt-1 text-base tracking-[0.3em] uppercase text-sm">Electronics</p>
          </div>
          <div className="w-12 h-0.5 bg-[#E14A5C] mx-auto" />
          <div className="space-y-5 text-left">
            {trustPoints.map((point) => (
              <div key={point.text} className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-[#E14A5C]/10 border border-[#E14A5C]/20 flex items-center justify-center flex-shrink-0">
                  <point.icon className="w-4 h-4 text-[#E14A5C]" />
                </div>
                <span className="text-sm text-white/70">{point.text}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Right panel */}
      <div className="flex flex-col justify-center items-center p-8 bg-white">
        <div className="w-full max-w-sm space-y-6">
          {/* Mobile logo */}
          <div className="lg:hidden text-center mb-2">
            <span className="font-heading font-extrabold text-2xl text-[#0D0625]">NEST</span>
            <span className="text-[#E14A5C] font-bold text-xs tracking-widest ml-2 uppercase">Electronics</span>
          </div>

          <div className="text-center">
            <h1 className="font-heading font-bold text-2xl text-[#0D0625]">Welcome back</h1>
            <p className="text-[#777] mt-1 text-sm">Sign in to your account</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            {error && (
              <div className="rounded-md bg-red-50 border border-red-200 p-3 text-sm text-red-600">{error}</div>
            )}

            <div className="space-y-1.5">
              <label htmlFor="email" className="text-sm font-medium text-[#333]">Email</label>
              <input
                id="email" type="email" value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full rounded-md border border-[#e0e0e0] px-3 py-2.5 text-sm text-[#0D0625] placeholder:text-[#aaa] focus:border-[#E14A5C] focus:outline-none focus:ring-2 focus:ring-[#E14A5C]/10 transition-colors"
                placeholder="you@example.com" required
              />
            </div>

            <div className="space-y-1.5">
              <div className="flex items-center justify-between">
                <label htmlFor="password" className="text-sm font-medium text-[#333]">Password</label>
                <Link href={ROUTES.forgotPassword} className="text-xs text-[#E14A5C] hover:underline">Forgot?</Link>
              </div>
              <div className="relative">
                <input
                  id="password" type={showPassword ? 'text' : 'password'} value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full rounded-md border border-[#e0e0e0] px-3 py-2.5 pr-10 text-sm text-[#0D0625] placeholder:text-[#aaa] focus:border-[#E14A5C] focus:outline-none focus:ring-2 focus:ring-[#E14A5C]/10 transition-colors"
                  placeholder="••••••••" required
                />
                <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#aaa] hover:text-[#555]" tabIndex={-1}>
                  {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                </button>
              </div>
            </div>

            <button
              type="submit" disabled={loading}
              className="w-full bg-[#E14A5C] hover:bg-[#c93e4e] text-white py-2.5 rounded-md font-semibold text-sm disabled:opacity-50 transition-colors"
            >
              {loading ? 'Signing in…' : 'Sign In'}
            </button>

            <div className="relative">
              <div className="absolute inset-0 flex items-center"><div className="w-full border-t border-[#e8e8e8]" /></div>
              <div className="relative flex justify-center text-xs"><span className="bg-white px-3 text-[#aaa]">or continue with</span></div>
            </div>

            <button
              type="button" onClick={handleGoogleLogin}
              className="w-full border border-[#e0e0e0] text-[#333] py-2.5 rounded-md font-medium text-sm flex items-center justify-center gap-2 hover:bg-[#f8f8f8] transition-colors"
            >
              <svg className="w-4 h-4" viewBox="0 0 24 24">
                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 01-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/>
                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
              Continue with Google
            </button>

            <p className="text-center text-sm text-[#777]">
              Don't have an account?{' '}
              <Link href={ROUTES.register} className="text-[#E14A5C] font-semibold hover:underline">Register</Link>
            </p>
          </form>
        </div>
      </div>
    </div>
  );
}
