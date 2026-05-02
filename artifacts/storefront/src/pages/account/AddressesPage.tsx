import { useEffect, useState } from 'react';
import { MapPin, Plus, Pencil, Trash2, Loader2, X } from 'lucide-react';
import { getSupabaseClient } from '@/lib/supabase';
import { EGYPTIAN_GOVERNORATES } from '@/lib/constants';

interface AddressData { id: string; label: string; full_name: string; phone: string; street: string; city: string; governorate: string; is_default: boolean; }
interface AddressFormData { label: string; full_name: string; phone: string; street: string; city: string; governorate: string; }

const emptyForm: AddressFormData = { label: '', full_name: '', phone: '', street: '', city: '', governorate: '' };

const INPUT_CLASS = 'w-full rounded-md border border-[#e0e0e0] px-3 py-2.5 text-sm text-[#0D0625] placeholder:text-[#aaa] bg-white focus:outline-none focus:ring-2 focus:ring-[#E14A5C]/10 focus:border-[#E14A5C] transition-colors';

export default function AddressesPage() {
  const [addresses, setAddresses] = useState<AddressData[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<AddressFormData>(emptyForm);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [userId, setUserId] = useState('');

  const supabase = getSupabaseClient();

  const loadAddresses = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    if (!session?.user) { setIsLoading(false); return; }
    setUserId(session.user.id);
    const { data } = await supabase.from('addresses').select('*').eq('user_id', session.user.id).order('created_at', { ascending: false });
    setAddresses(data ?? []);
    setIsLoading(false);
  };

  useEffect(() => { loadAddresses(); }, []);

  const closeForm = () => { setShowForm(false); setEditingId(null); setForm(emptyForm); setError(''); };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (!form.full_name.trim() || !form.phone.trim() || !form.street.trim() || !form.city.trim() || !form.governorate) {
      setError('Please fill in all required fields.'); return;
    }
    setSaving(true);
    if (editingId) {
      const { error: updateError } = await supabase.from('addresses').update({ label: form.label.trim() || null, full_name: form.full_name.trim(), phone: form.phone.trim(), street: form.street.trim(), city: form.city.trim(), governorate: form.governorate }).eq('id', editingId);
      if (updateError) { setError(updateError.message); setSaving(false); return; }
      setAddresses(prev => prev.map(a => a.id === editingId ? { ...a, ...form } : a));
    } else {
      const { data: newAddr, error: insertError } = await supabase.from('addresses').insert({ user_id: userId, label: form.label.trim() || null, full_name: form.full_name.trim(), phone: form.phone.trim(), street: form.street.trim(), city: form.city.trim(), governorate: form.governorate, is_default: addresses.length === 0 }).select().single();
      if (insertError) { setError(insertError.message); setSaving(false); return; }
      setAddresses(prev => [newAddr as AddressData, ...prev]);
    }
    setSaving(false);
    closeForm();
  };

  const handleDelete = async (id: string) => {
    await supabase.from('addresses').delete().eq('id', id);
    setAddresses(prev => prev.filter(a => a.id !== id));
  };

  const handleSetDefault = async (id: string) => {
    await supabase.from('addresses').update({ is_default: true }).eq('id', id);
    setAddresses(prev => prev.map(a => ({ ...a, is_default: a.id === id })));
  };

  if (isLoading) return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div className="h-8 w-32 bg-[#f2f2f2] animate-pulse rounded" />
      </div>
      <div className="bg-white border border-[#e8e8e8] rounded-lg p-6 space-y-3">
        {Array.from({ length: 2 }).map((_, i) => <div key={i} className="h-20 bg-[#f2f2f2] rounded-md animate-pulse" />)}
      </div>
    </div>
  );

  if (!userId) return (
    <div className="text-center py-16 bg-white border border-[#e8e8e8] rounded-lg">
      <div className="w-16 h-16 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
        <MapPin className="w-8 h-8 text-[#E14A5C]/40" />
      </div>
      <h2 className="font-heading font-semibold text-lg text-[#0D0625]">Sign in to manage addresses</h2>
    </div>
  );

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <h2 className="font-heading font-bold text-xl text-[#0D0625]">Addresses</h2>
        {!showForm && (
          <button
            onClick={() => { setForm(emptyForm); setEditingId(null); setError(''); setShowForm(true); }}
            className="flex items-center gap-1.5 px-3 py-1.5 text-sm border border-[#E14A5C] text-[#E14A5C] rounded-md hover:bg-[#fde8ea] transition-colors font-medium"
          >
            <Plus className="w-4 h-4" /> Add Address
          </button>
        )}
      </div>

      {showForm && (
        <form onSubmit={handleSubmit} className="bg-white border border-[#e8e8e8] rounded-lg p-6 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-heading font-semibold text-[#0D0625]">{editingId ? 'Edit Address' : 'New Address'}</h3>
            <button type="button" onClick={closeForm} className="p-1 rounded hover:bg-[#f8f8f8] text-[#aaa] hover:text-[#555] transition-colors">
              <X className="w-4 h-4" />
            </button>
          </div>
          {error && <div className="rounded-md bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700">{error}</div>}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {[
              { key: 'label',     label: 'Label',      placeholder: 'Home, Work, etc.' },
              { key: 'full_name', label: 'Full Name *', placeholder: 'Recipient name' },
              { key: 'phone',     label: 'Phone *',     placeholder: '+20 1XX XXX XXXX' },
              { key: 'street',    label: 'Street *',    placeholder: 'Street address' },
              { key: 'city',      label: 'City *',      placeholder: 'City' },
            ].map(({ key, label, placeholder }) => (
              <div key={key} className="space-y-1.5">
                <label className="text-sm font-medium text-[#333]">{label}</label>
                <input type="text" value={(form as any)[key]} onChange={(e) => setForm(f => ({ ...f, [key]: e.target.value }))} className={INPUT_CLASS} placeholder={placeholder} />
              </div>
            ))}
            <div className="space-y-1.5">
              <label className="text-sm font-medium text-[#333]">Governorate *</label>
              <select value={form.governorate} onChange={(e) => setForm(f => ({ ...f, governorate: e.target.value }))} className={INPUT_CLASS}>
                <option value="" disabled>Select governorate</option>
                {EGYPTIAN_GOVERNORATES.map((gov) => <option key={gov} value={gov}>{gov}</option>)}
              </select>
            </div>
          </div>
          <div className="flex gap-3 pt-1">
            <button type="submit" disabled={saving} className="inline-flex items-center gap-2 px-5 py-2.5 bg-[#E14A5C] hover:bg-[#c93e4e] text-white text-sm rounded-md font-semibold disabled:opacity-50 transition-colors">
              {saving
                ? <><Loader2 className="w-4 h-4 animate-spin" />{editingId ? 'Saving…' : 'Adding…'}</>
                : <>{editingId ? 'Save Changes' : 'Add Address'}</>}
            </button>
            <button type="button" onClick={closeForm} className="px-4 py-2.5 text-sm text-[#555] hover:text-[#0D0625] transition-colors">Cancel</button>
          </div>
        </form>
      )}

      {!showForm && addresses.length === 0 && (
        <div className="text-center py-16 bg-white border border-[#e8e8e8] rounded-lg">
          <div className="w-16 h-16 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
            <MapPin className="w-8 h-8 text-[#E14A5C]/40" />
          </div>
          <h3 className="font-heading font-semibold text-lg text-[#0D0625]">No addresses saved</h3>
          <p className="text-[#777] text-sm mt-1">Save your shipping details for faster checkout.</p>
        </div>
      )}

      {!showForm && addresses.length > 0 && (
        <div className="space-y-3">
          {addresses.map((address) => (
            <div key={address.id} className="bg-white border border-[#e8e8e8] rounded-lg p-5 hover:border-[#E14A5C]/30 transition-colors">
              <div className="flex items-center gap-2 mb-2">
                {address.is_default && (
                  <span className="inline-flex items-center rounded-full bg-[#fde8ea] text-[#E14A5C] px-2.5 py-0.5 text-xs font-semibold">Default</span>
                )}
                {address.label && (
                  <span className="inline-flex items-center rounded-full bg-[#f5f5f5] px-2.5 py-0.5 text-xs font-medium text-[#555]">{address.label}</span>
                )}
              </div>
              <div className="text-sm space-y-1">
                <p className="font-semibold text-[#0D0625]">{address.full_name}</p>
                <p className="text-[#777]">{address.phone}</p>
                <p className="text-[#777]">{address.street}</p>
                <p className="text-[#777]">{address.city}, {address.governorate}</p>
              </div>
              <div className="flex items-center gap-1 mt-3 pt-3 border-t border-[#f5f5f5]">
                <button
                  onClick={() => { setForm({ label: address.label, full_name: address.full_name, phone: address.phone, street: address.street, city: address.city, governorate: address.governorate }); setEditingId(address.id); setError(''); setShowForm(true); }}
                  className="flex items-center gap-1.5 px-2.5 py-1.5 text-sm text-[#555] hover:text-[#0D0625] hover:bg-[#f8f8f8] rounded transition-colors"
                >
                  <Pencil className="w-3.5 h-3.5" /> Edit
                </button>
                <button
                  onClick={() => handleDelete(address.id)}
                  className="flex items-center gap-1.5 px-2.5 py-1.5 text-sm text-red-400 hover:text-red-600 hover:bg-red-50 rounded transition-colors"
                >
                  <Trash2 className="w-3.5 h-3.5" /> Delete
                </button>
                {!address.is_default && (
                  <button
                    onClick={() => handleSetDefault(address.id)}
                    className="flex items-center gap-1.5 px-2.5 py-1.5 text-sm text-[#E14A5C] hover:bg-[#fde8ea] rounded transition-colors font-medium ml-auto"
                  >
                    Set as Default
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
