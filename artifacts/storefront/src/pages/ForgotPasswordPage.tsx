import { useState } from 'react';
import { Link } from 'wouter';
import { Mail } from 'lucide-react';
import { createBrowserClient } from '@supabase/ssr';
import { ROUTES } from '@/lib/constants';

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState('');
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
    if (!email || !email.includes('@')) { setError('Please enter a valid email address'); return; }
    setLoading(true);
    const { error: resetError } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/account/profile`,
    });
    if (resetError) { setError(resetError.message); setLoading(false); return; }
    setSuccess(true);
    setLoading(false);
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-8 bg-[#f8f8f8]">
      <div className="w-full max-w-sm bg-white rounded-lg border border-[#e8e8e8] p-8 space-y-6 shadow-sm">
        <div className="text-center">
          <div className="w-14 h-14 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
            <Mail className="w-6 h-6 text-[#E14A5C]" />
          </div>
          <h1 className="font-heading font-bold text-2xl text-[#0D0625]">Reset password</h1>
          <p className="text-[#777] mt-1 text-sm">Enter your email to receive a reset link</p>
        </div>

        {success ? (
          <div className="space-y-4">
            <div className="rounded-md bg-green-50 border border-green-200 p-4 text-center text-sm text-green-700">
              Check your email for a password reset link.
            </div>
            <p className="text-center text-sm text-[#777]">
              <Link href={ROUTES.login} className="text-[#E14A5C] font-semibold hover:underline">Back to sign in</Link>
            </p>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            {error && <div className="rounded-md bg-red-50 border border-red-200 p-3 text-sm text-red-600">{error}</div>}
            <div className="space-y-1.5">
              <label htmlFor="email" className="text-sm font-medium text-[#333]">Email address</label>
              <input
                id="email" type="email" value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full rounded-md border border-[#e0e0e0] px-3 py-2.5 text-sm text-[#0D0625] placeholder:text-[#aaa] focus:border-[#E14A5C] focus:outline-none focus:ring-2 focus:ring-[#E14A5C]/10 transition-colors"
                placeholder="you@example.com" required
              />
            </div>
            <button
              type="submit" disabled={loading}
              className="w-full bg-[#E14A5C] hover:bg-[#c93e4e] text-white py-2.5 rounded-md font-semibold text-sm disabled:opacity-50 transition-colors"
            >
              {loading ? 'Sending…' : 'Send Reset Link'}
            </button>
            <p className="text-center text-sm text-[#777]">
              Remember your password?{' '}
              <Link href={ROUTES.login} className="text-[#E14A5C] font-semibold hover:underline">Sign in</Link>
            </p>
          </form>
        )}
      </div>
    </div>
  );
}
