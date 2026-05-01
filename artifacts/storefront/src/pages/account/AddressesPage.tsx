import { useEffect, useState } from 'react';
import { MapPin, Plus, Pencil, Trash2, Loader2, X } from 'lucide-react';
import { getSupabaseClient } from '@/lib/supabase';
import { EGYPTIAN_GOVERNORATES } from '@/lib/constants';

interface AddressData { id: string; label: string; full_name: string; phone: string; street: string; city: string; governorate: string; is_default: boolean; }
interface AddressFormData { label: string; full_name: string; phone: string; street: string; city: string; governorate: string; }

const emptyForm: AddressFormData = { label: '', full_name: '', phone: '', street: '', city: '', governorate: '' };

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
      <div className="flex items-center justify-between"><h2 className="text-2xl font-bold text-slate-900">Addresses</h2></div>
      <div className="bg-white border border-slate-200 rounded-md p-6 space-y-3">
        {Array.from({ length: 2 }).map((_, i) => <div key={i} className="h-20 bg-slate-100 rounded-md animate-pulse" />)}
      </div>
    </div>
  );

  if (!userId) return (
    <div className="text-center py-16 bg-white border border-slate-200 rounded-md">
      <MapPin className="w-12 h-12 mx-auto text-slate-300 mb-4" />
      <h2 className="text-lg font-medium text-slate-900">Sign in to manage addresses</h2>
    </div>
  );

  const inputClass = 'w-full rounded-md border border-slate-200 px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors placeholder:text-slate-300';

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-slate-900">Addresses</h2>
        {!showForm && (
          <button onClick={() => { setForm(emptyForm); setEditingId(null); setError(''); setShowForm(true); }} className="flex items-center gap-1 px-3 py-1.5 text-sm border border-slate-200 rounded-md bg-white hover:bg-slate-50 transition-colors">
            <Plus className="w-4 h-4" /> Add Address
          </button>
        )}
      </div>

      {showForm && (
        <form onSubmit={handleSubmit} className="bg-white border border-slate-200 rounded-md p-6 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-semibold text-slate-900">{editingId ? 'Edit Address' : 'New Address'}</h3>
            <button type="button" onClick={closeForm} className="p-1 rounded hover:bg-slate-100 text-slate-400"><X className="w-4 h-4" /></button>
          </div>
          {error && <div className="rounded-md bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700">{error}</div>}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {[
              { key: 'label', label: 'Label', placeholder: 'Home, Work, etc.' },
              { key: 'full_name', label: 'Full Name *', placeholder: 'Recipient name' },
              { key: 'phone', label: 'Phone *', placeholder: '+20 1XX XXX XXXX' },
              { key: 'street', label: 'Street *', placeholder: 'Street address' },
              { key: 'city', label: 'City *', placeholder: 'City' },
            ].map(({ key, label, placeholder }) => (
              <div key={key} className="space-y-2">
                <label className="text-sm font-medium text-slate-700">{label}</label>
                <input type="text" value={(form as any)[key]} onChange={(e) => setForm(f => ({ ...f, [key]: e.target.value }))} className={inputClass} placeholder={placeholder} />
              </div>
            ))}
            <div className="space-y-2">
              <label className="text-sm font-medium text-slate-700">Governorate *</label>
              <select value={form.governorate} onChange={(e) => setForm(f => ({ ...f, governorate: e.target.value }))} className={inputClass}>
                <option value="" disabled>Select governorate</option>
                {EGYPTIAN_GOVERNORATES.map((gov) => <option key={gov} value={gov}>{gov}</option>)}
              </select>
            </div>
          </div>
          <div className="flex gap-3 pt-2">
            <button type="submit" disabled={saving} className="inline-flex items-center gap-2 px-4 py-2 bg-blue-600 text-white text-sm rounded-md font-medium hover:bg-blue-700 disabled:opacity-50 transition-colors">
              {saving ? <><Loader2 className="w-4 h-4 animate-spin" />{editingId ? 'Saving...' : 'Adding...'}</> : <>{editingId ? 'Save Changes' : 'Add Address'}</>}
            </button>
            <button type="button" onClick={closeForm} className="px-4 py-2 text-sm text-slate-600 hover:text-slate-900 transition-colors">Cancel</button>
          </div>
        </form>
      )}

      {!showForm && addresses.length === 0 && (
        <div className="text-center py-16 bg-white border border-slate-200 rounded-md">
          <MapPin className="w-12 h-12 mx-auto text-slate-300 mb-4" />
          <h3 className="text-lg font-medium text-slate-900">No addresses saved</h3>
          <p className="text-slate-500 mt-1">Save your shipping details for faster checkout.</p>
        </div>
      )}

      {!showForm && addresses.length > 0 && (
        <div className="space-y-3">
          {addresses.map((address) => (
            <div key={address.id} className="bg-white border border-slate-200 rounded-md p-5">
              <div className="flex items-center gap-2 mb-2">
                {address.is_default && <span className="inline-flex items-center rounded-full bg-blue-50 text-blue-700 px-2.5 py-0.5 text-xs font-medium">Default</span>}
                {address.label && <span className="inline-flex items-center rounded-full bg-slate-100 px-2.5 py-0.5 text-xs font-medium text-slate-600">{address.label}</span>}
              </div>
              <div className="text-sm space-y-1">
                <p className="font-medium text-slate-900">{address.full_name}</p>
                <p className="text-slate-500">{address.phone}</p>
                <p className="text-slate-500">{address.street}</p>
                <p className="text-slate-500">{address.city}, {address.governorate}</p>
              </div>
              <div className="flex items-center gap-1 mt-4 pt-3 border-t border-slate-100">
                <button onClick={() => { setForm({ label: address.label, full_name: address.full_name, phone: address.phone, street: address.street, city: address.city, governorate: address.governorate }); setEditingId(address.id); setError(''); setShowForm(true); }} className="flex items-center gap-1.5 px-2 py-1.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 rounded transition-colors">
                  <Pencil className="w-4 h-4" /> Edit
                </button>
                <button onClick={() => handleDelete(address.id)} className="flex items-center gap-1.5 px-2 py-1.5 text-sm text-red-400 hover:text-red-600 hover:bg-red-50 rounded transition-colors">
                  <Trash2 className="w-4 h-4" /> Delete
                </button>
                {!address.is_default && (
                  <button onClick={() => handleSetDefault(address.id)} className="flex items-center gap-1.5 px-2 py-1.5 text-sm text-slate-500 hover:text-slate-900 hover:bg-slate-50 rounded transition-colors">
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
