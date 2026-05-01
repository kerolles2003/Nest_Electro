import { useEffect, useState } from 'react';
import { User, Mail, Phone, Save, Loader2 } from 'lucide-react';
import { getSupabaseClient } from '@/lib/supabase';

export default function ProfilePage() {
  const [profile, setProfile] = useState({ full_name: '', phone: '', email: '' });
  const [originalFullName, setOriginalFullName] = useState('');
  const [originalPhone, setOriginalPhone] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  useEffect(() => {
    const load = async () => {
      const supabase = getSupabaseClient();
      const { data: { session } } = await supabase.auth.getSession();
      const user = session?.user;
      if (!user) { setLoading(false); return; }
      const { data: profileData } = await supabase.from('profiles').select('full_name, phone').eq('id', user.id).single();
      setProfile({ full_name: profileData?.full_name ?? '', phone: profileData?.phone ?? '', email: user.email ?? '' });
      setOriginalFullName(profileData?.full_name ?? '');
      setOriginalPhone(profileData?.phone ?? '');
      setLoading(false);
    };
    load();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMessage(null);
    const trimmedName = profile.full_name.trim();
    const trimmedPhone = profile.phone.trim();
    if (!trimmedName) { setMessage({ type: 'error', text: 'Full name is required.' }); return; }
    setSaving(true);
    const supabase = getSupabaseClient();
    const { data: { session } } = await supabase.auth.getSession();
    if (!session?.user) { setMessage({ type: 'error', text: 'Not authenticated.' }); setSaving(false); return; }
    const { error } = await supabase.from('profiles').upsert({ id: session.user.id, full_name: trimmedName, phone: trimmedPhone || null }, { onConflict: 'id' });
    if (error) { setMessage({ type: 'error', text: error.message }); }
    else { setMessage({ type: 'success', text: 'Profile updated successfully.' }); setOriginalFullName(trimmedName); setOriginalPhone(trimmedPhone); }
    setSaving(false);
  };

  const hasChanges = profile.full_name.trim() !== originalFullName || profile.phone.trim() !== originalPhone;

  if (loading) return (
    <div className="space-y-4">
      <h2 className="text-2xl font-bold text-slate-900">Profile</h2>
      <div className="bg-white border border-slate-200 rounded-md p-6 space-y-4">
        {Array.from({ length: 3 }).map((_, i) => <div key={i} className="h-10 bg-slate-100 rounded-md animate-pulse" />)}
      </div>
    </div>
  );

  if (!profile.email) return (
    <div className="text-center py-16 bg-white border border-slate-200 rounded-md">
      <User className="w-12 h-12 mx-auto text-slate-300 mb-4" />
      <h2 className="text-lg font-medium text-slate-900">Sign in to view your profile</h2>
    </div>
  );

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-slate-900">Profile</h2>
      <form onSubmit={handleSubmit} className="bg-white border border-slate-200 rounded-md p-6 space-y-5">
        {message && (
          <div className={`rounded-md px-4 py-3 text-sm ${message.type === 'success' ? 'bg-green-50 text-green-700 border border-green-200' : 'bg-red-50 text-red-700 border border-red-200'}`}>
            {message.text}
          </div>
        )}
        {[
          { id: 'full_name', label: 'Full Name', icon: User, type: 'text', placeholder: 'Your full name', disabled: false, value: profile.full_name, onChange: (v: string) => setProfile(p => ({ ...p, full_name: v })) },
          { id: 'email', label: 'Email', icon: Mail, type: 'email', placeholder: '', disabled: true, value: profile.email, onChange: () => {} },
          { id: 'phone', label: 'Phone', icon: Phone, type: 'tel', placeholder: '+20 1XX XXX XXXX', disabled: false, value: profile.phone, onChange: (v: string) => setProfile(p => ({ ...p, phone: v })) },
        ].map(({ id, label, icon: Icon, type, placeholder, disabled, value, onChange }) => (
          <div key={id} className="space-y-2">
            <label htmlFor={id} className="text-sm font-medium text-slate-700">{label}</label>
            <div className="relative">
              <Icon className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input
                id={id} type={type} value={value} disabled={disabled}
                onChange={(e) => onChange(e.target.value)}
                placeholder={placeholder}
                className={`w-full rounded-md border border-slate-200 px-3 py-2 pl-9 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors ${disabled ? 'bg-slate-50 text-slate-400 cursor-not-allowed' : 'bg-white'}`}
              />
            </div>
            {id === 'email' && <p className="text-xs text-slate-400">Email cannot be changed.</p>}
          </div>
        ))}
        <button type="submit" disabled={!hasChanges || saving} className="inline-flex items-center gap-2 px-4 py-2 bg-blue-600 text-white text-sm rounded-md font-medium hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors">
          {saving ? <><Loader2 className="w-4 h-4 animate-spin" />Saving...</> : <><Save className="w-4 h-4" />Save Changes</>}
        </button>
      </form>
    </div>
  );
}
