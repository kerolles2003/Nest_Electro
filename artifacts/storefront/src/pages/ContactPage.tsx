import { useState } from 'react';
import { Mail, Phone, MapPin, Clock, Send } from 'lucide-react';

const contactInfo = [
  { icon: Mail, label: 'Email', value: 'support@nest-electronics.com' },
  { icon: Phone, label: 'Phone', value: '+20 100 000 0000' },
  { icon: MapPin, label: 'Location', value: 'Cairo, Egypt' },
  { icon: Clock, label: 'Hours', value: 'Sat–Thu, 9am – 6pm' },
];

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
    <div className="container-nest py-12 grid grid-cols-1 lg:grid-cols-2 gap-12">
      <div>
        <h1 className="text-2xl font-heading font-semibold text-slate-900 mb-2">Get in Touch</h1>
        <p className="text-base text-slate-500 mb-8">Our team of engineers is ready to help you with your project.</p>
        <div className="space-y-4">
          {contactInfo.map((item, i) => (
            <div key={i} className="flex items-start gap-3">
              <item.icon className="text-blue-600 w-5 h-5 mt-0.5" strokeWidth={1.5} />
              <div>
                <p className="text-xs text-slate-500 uppercase tracking-wide">{item.label}</p>
                <p className="text-sm text-slate-900 font-medium">{item.value}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="bg-white border border-slate-200 rounded-lg p-6 shadow-sm">
        <h2 className="text-lg font-heading font-semibold text-slate-900 mb-4">Send us a Message</h2>
        {submitted ? (
          <div className="p-4 bg-green-50 border border-green-200 rounded-md text-green-700 text-sm">
            Thank you! Your message has been sent successfully. We will get back to you soon.
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            {[
              { key: 'name', label: 'Name', type: 'text', placeholder: 'Your name' },
              { key: 'email', label: 'Email', type: 'email', placeholder: 'you@example.com' },
              { key: 'subject', label: 'Subject', type: 'text', placeholder: 'How can we help?' },
            ].map(({ key, label, type, placeholder }) => (
              <div key={key}>
                <label className="block text-xs font-medium text-slate-500 mb-1">{label}</label>
                <input
                  type={type}
                  value={(formData as any)[key]}
                  onChange={(e) => setFormData({ ...formData, [key]: e.target.value })}
                  className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-200"
                  placeholder={placeholder}
                />
                {errors[key] && <p className="text-xs text-red-500 mt-1">{errors[key]}</p>}
              </div>
            ))}
            <div>
              <label className="block text-xs font-medium text-slate-500 mb-1">Message</label>
              <textarea
                rows={5}
                value={formData.message}
                onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-200 resize-none"
                placeholder="Tell us more about your inquiry..."
              />
              {errors.message && <p className="text-xs text-red-500 mt-1">{errors.message}</p>}
            </div>
            <button
              type="submit"
              disabled={submitting}
              className="w-full py-2.5 text-sm flex items-center justify-center gap-2 bg-blue-600 text-white rounded-md font-medium hover:bg-blue-700 disabled:opacity-60 transition-colors"
            >
              <Send className="w-4 h-4" />
              {submitting ? 'Sending...' : 'Send Message'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
}
