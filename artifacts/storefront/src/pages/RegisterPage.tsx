import { useState } from 'react';
import { Link } from 'wouter';
import { Eye, EyeOff } from 'lucide-react';
import { createBrowserClient } from '@supabase/ssr';
import { ROUTES } from '@/lib/constants';

const INPUT_CLASS = 'w-full rounded-md border border-[#e0e0e0] px-3 py-2.5 text-sm text-[#0D0625] placeholder:text-[#aaa] focus:border-[#E14A5C] focus:outline-none focus:ring-2 focus:ring-[#E14A5C]/10 transition-colors';

export default function RegisterPage() {
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const supabase = createBrowserClient(
    import.meta.env.VITE_SUPABASE_URL!,
    import.meta.env.VITE_SUPABASE_ANON_KEY!
  );

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (!fullName.trim() || fullName.trim().length < 2) { setError('Full name must be at least 2 characters.'); return; }
    if (!email || !email.includes('@')) { setError('Enter a valid email.'); return; }
    if (password.length < 8) { setError('Password must be at least 8 characters.'); return; }
    if (password !== confirmPassword) { setError('Passwords do not match.'); return; }
    setLoading(true);
    const { error: authError } = await supabase.auth.signUp({ email, password, options: { data: { full_name: fullName } } });
    if (authError) { setError(authError.message); setLoading(false); return; }
    setSuccess(true);
    setLoading(false);
  };

  if (success) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center p-8 bg-[#f8f8f8]">
        <div className="w-full max-w-sm space-y-4">
          <div className="bg-white rounded-lg border border-[#e8e8e8] p-8 text-center space-y-4">
            <div className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center mx-auto">
              <svg className="w-8 h-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" /></svg>
            </div>
            <h2 className="font-heading font-bold text-xl text-[#0D0625]">Check your email</h2>
            <p className="text-sm text-[#777]">We sent a confirmation link to <strong className="text-[#0D0625]">{email}</strong>. Click it to activate your account.</p>
          </div>
          <p className="text-center text-sm text-[#777]">
            <Link href={ROUTES.login} className="text-[#E14A5C] font-semibold hover:underline">Back to sign in</Link>
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen grid grid-cols-1 lg:grid-cols-2">
      {/* Left decorative panel */}
      <div className="hidden lg:flex flex-col justify-center items-center bg-[#0D0625] p-12 text-white relative overflow-hidden">
        <div className="absolute -top-20 -left-20 w-72 h-72 rounded-full bg-[#E14A5C] opacity-5" />
        <div className="absolute bottom-10 right-10 w-48 h-48 rounded-full bg-[#E14A5C] opacity-5" />
        <div className="relative text-center space-y-4">
          <p className="text-[11px] font-bold uppercase tracking-widest text-[#E14A5C]">Join</p>
          <h2 className="font-heading font-extrabold text-5xl tracking-tight text-white">NEST</h2>
          <p className="text-white/40 tracking-[0.3em] uppercase text-sm">Electronics</p>
          <div className="w-12 h-0.5 bg-[#E14A5C] mx-auto" />
          <p className="text-white/50 text-sm max-w-xs leading-relaxed">
            Egypt's home for Arduino, sensors, motors & 500+ electronics components. Sign up and start building.
          </p>
        </div>
      </div>

      {/* Right form */}
      <div className="flex flex-col justify-center items-center p-8 bg-white">
        <div className="w-full max-w-sm space-y-6">
          <div className="lg:hidden text-center mb-2">
            <span className="font-heading font-extrabold text-2xl text-[#0D0625]">NEST</span>
            <span className="text-[#E14A5C] font-bold text-xs tracking-widest ml-2 uppercase">Electronics</span>
          </div>

          <div className="text-center">
            <h1 className="font-heading font-bold text-2xl text-[#0D0625]">Create an account</h1>
            <p className="text-[#777] mt-1 text-sm">Join Nest Electronics</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            {error && (
              <div className="rounded-md bg-red-50 border border-red-200 p-3 text-sm text-red-600">{error}</div>
            )}

            <div className="space-y-1.5">
              <label htmlFor="fullName" className="text-sm font-medium text-[#333]">Full Name</label>
              <input id="fullName" type="text" value={fullName} onChange={(e) => setFullName(e.target.value)} className={INPUT_CLASS} placeholder="Your name" required />
            </div>

            <div className="space-y-1.5">
              <label htmlFor="email" className="text-sm font-medium text-[#333]">Email</label>
              <input id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} className={INPUT_CLASS} placeholder="you@example.com" required />
            </div>

            <div className="space-y-1.5">
              <label htmlFor="password" className="text-sm font-medium text-[#333]">Password</label>
              <div className="relative">
                <input id="password" type={showPassword ? 'text' : 'password'} value={password} onChange={(e) => setPassword(e.target.value)} className={INPUT_CLASS + ' pr-10'} placeholder="Min. 8 characters" required />
                <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#aaa] hover:text-[#555]" tabIndex={-1}>
                  {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                </button>
              </div>
            </div>

            <div className="space-y-1.5">
              <label htmlFor="confirmPassword" className="text-sm font-medium text-[#333]">Confirm Password</label>
              <input id="confirmPassword" type="password" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} className={INPUT_CLASS} placeholder="••••••••" required />
            </div>

            <button
              type="submit" disabled={loading}
              className="w-full bg-[#E14A5C] hover:bg-[#c93e4e] text-white py-2.5 rounded-md font-semibold text-sm disabled:opacity-50 transition-colors"
            >
              {loading ? 'Creating account…' : 'Create Account'}
            </button>

            <p className="text-center text-sm text-[#777]">
              Already have an account?{' '}
              <Link href={ROUTES.login} className="text-[#E14A5C] font-semibold hover:underline">Sign in</Link>
            </p>
          </form>
        </div>
      </div>
    </div>
  );
}
