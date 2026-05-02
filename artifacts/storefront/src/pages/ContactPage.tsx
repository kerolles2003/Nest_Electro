import { useState } from 'react';
import { Mail, Phone, MapPin, Clock, Send, ChevronRight } from 'lucide-react';
import { Link } from 'wouter';

const contactInfo = [
  { icon: Mail,  label: 'Email',    value: 'support@nest-electronics.com' },
  { icon: Phone, label: 'Phone',    value: '+20 100 000 0000' },
  { icon: MapPin,label: 'Location', value: 'Cairo, Egypt' },
  { icon: Clock, label: 'Hours',    value: 'Sat–Thu, 9am – 6pm' },
];

const INPUT_CLASS = 'w-full rounded-md border border-[#e0e0e0] px-3 py-2.5 text-sm text-[#0D0625] placeholder:text-[#aaa] bg-white focus:outline-none focus:border-[#E14A5C] focus:ring-2 focus:ring-[#E14A5C]/10 transition-colors';

export default function ContactPage() {
  const [formData, setFormData] = useState({ name: '', email: '', subject: '', message: '' });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [submitted, setSubmitted] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  const validate = () => {
    const newErrors: Record<string, string> = {};
    if (!formData.name || formData.name.length < 2) newErrors.name = 'Name is required';
    if (!formData.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) newErrors.email = 'Invalid email address';
    if (!formData.subject || formData.subject.length < 3) newErrors.subject = 'Subject is required';
    if (!formData.message || formData.message.length < 20) newErrors.message = 'Message must be at least 20 characters';
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    setSubmitting(true);
    await new Promise((resolve) => setTimeout(resolve, 1000));
    setSubmitting(false);
    setSubmitted(true);
  };

  return (
    <div className="bg-[#f8f8f8] min-h-screen">
      <div className="container-nest py-10">
        <nav className="flex items-center gap-1.5 text-xs text-[#999] mb-6">
          <Link href="/" className="hover:text-[#E14A5C] transition-colors">Home</Link>
          <ChevronRight className="w-3 h-3" />
          <span className="text-[#0D0625] font-medium">Contact</span>
        </nav>

        <div className="grid grid-cols-1 lg:grid-cols-5 gap-8">
          {/* Left info panel */}
          <div className="lg:col-span-2 space-y-6">
            <div>
              <h1 className="font-heading font-bold text-2xl text-[#0D0625] mb-2">Get in Touch</h1>
              <p className="text-[#777] text-sm leading-relaxed">Our team of engineers is ready to help you with your project — whether it's a quick question or a complex build.</p>
            </div>

            <div className="space-y-4">
              {contactInfo.map((item, i) => (
                <div key={i} className="flex items-start gap-3">
                  <div className="w-9 h-9 rounded-lg bg-[#fde8ea] flex items-center justify-center flex-shrink-0">
                    <item.icon className="text-[#E14A5C] w-4 h-4" strokeWidth={1.5} />
                  </div>
                  <div>
                    <p className="text-[10px] font-bold uppercase tracking-widest text-[#aaa]">{item.label}</p>
                    <p className="text-sm text-[#0D0625] font-medium mt-0.5">{item.value}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Right form */}
          <div className="lg:col-span-3 bg-white border border-[#e8e8e8] rounded-lg p-6 shadow-sm">
            <h2 className="font-heading font-bold text-lg text-[#0D0625] mb-5">Send us a Message</h2>
            {submitted ? (
              <div className="flex flex-col items-center text-center py-8 gap-4">
                <div className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center">
                  <svg className="w-8 h-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" /></svg>
                </div>
                <div>
                  <p className="font-heading font-bold text-lg text-[#0D0625]">Message Sent!</p>
                  <p className="text-[#777] text-sm mt-1">Thank you! We'll get back to you within 24 hours.</p>
                </div>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
                {[
                  { key: 'name',    label: 'Name',    type: 'text',  placeholder: 'Your name' },
                  { key: 'email',   label: 'Email',   type: 'email', placeholder: 'you@example.com' },
                  { key: 'subject', label: 'Subject', type: 'text',  placeholder: 'How can we help?' },
                ].map(({ key, label, type, placeholder }) => (
                  <div key={key}>
                    <label className="block text-sm font-medium text-[#333] mb-1.5">{label}</label>
                    <input
                      type={type}
                      value={(formData as any)[key]}
                      onChange={(e) => setFormData({ ...formData, [key]: e.target.value })}
                      className={INPUT_CLASS}
                      placeholder={placeholder}
                    />
                    {errors[key] && <p className="text-xs text-red-500 mt-1">{errors[key]}</p>}
                  </div>
                ))}
                <div>
                  <label className="block text-sm font-medium text-[#333] mb-1.5">Message</label>
                  <textarea
                    rows={5}
                    value={formData.message}
                    onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                    className={INPUT_CLASS + ' resize-none'}
                    placeholder="Tell us more about your inquiry…"
                  />
                  {errors.message && <p className="text-xs text-red-500 mt-1">{errors.message}</p>}
                </div>
                <button
                  type="submit" disabled={submitting}
                  className="w-full py-2.5 text-sm flex items-center justify-center gap-2 bg-[#E14A5C] hover:bg-[#c93e4e] text-white rounded-md font-semibold disabled:opacity-60 transition-colors"
                >
                  <Send className="w-4 h-4" />
                  {submitting ? 'Sending…' : 'Send Message'}
                </button>
              </form>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
