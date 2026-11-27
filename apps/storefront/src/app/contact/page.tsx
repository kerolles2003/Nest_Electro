'use client';

import { useState } from 'react';
import { Mail, MapPin, Clock, Send } from 'lucide-react';

/**
 * The support inbox this page writes to. It is the address displayed in the
 * contact information beside the form, so the two can never disagree.
 */
const SUPPORT_EMAIL = 'support@nest-electronics.com';

export default function ContactPage() {
  const [formData, setFormData] = useState({ name: '', email: '', subject: '', message: '' });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [opened, setOpened] = useState(false);

  const validate = () => {
    const newErrors: Record<string, string> = {};
    if (!formData.name || formData.name.length < 2) newErrors.name = 'Name is required';
    if (!formData.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) newErrors.email = 'Invalid email address';
    if (!formData.subject || formData.subject.length < 3) newErrors.subject = 'Subject is required';
    if (!formData.message || formData.message.length < 20) newErrors.message = 'Message must be at least 20 characters';
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  /*
   * F17 — this form used to fake delivery: it waited a second, showed
   * "sent successfully", and discarded the message. There is still no
   * contact-messages backend (and the owner's chosen channel is WhatsApp,
   * D16, whose number is not yet supplied), so the honest behaviour is to
   * hand the message to the visitor's OWN email client, addressed to the
   * support inbox, with everything they typed prefilled — and to say
   * exactly that. Nothing is claimed sent until they send it there.
   */
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;

    const body = `${formData.message}\n\n— ${formData.name} (${formData.email})`;
    const href = `mailto:${SUPPORT_EMAIL}?subject=${encodeURIComponent(formData.subject)}&body=${encodeURIComponent(body)}`;

    window.location.href = href;
    setOpened(true);
  };

  const contactInfo = [
    { icon: Mail, label: 'Email', value: SUPPORT_EMAIL },
    { icon: MapPin, label: 'Location', value: 'Cairo, Egypt' },
    { icon: Clock, label: 'Hours', value: 'Sat–Thu, 9am – 6pm' },
  ];

  return (
    <div className="container-nest py-12 grid grid-cols-1 lg:grid-cols-2 gap-12">
      {/* Left Info */}
      <div>
        <h1 className="text-2xl font-heading font-semibold text-foreground mb-2">Get in Touch</h1>
        <p className="text-base text-foreground-muted mb-8">
          Our team of engineers is ready to help you with your project.
        </p>
        <div className="space-y-4">
          {contactInfo.map((item, i) => (
            <div key={i} className="flex items-start gap-3">
              <item.icon className="text-primary text-lg mt-0.5" strokeWidth={1.5} />
              <div>
                <p className="text-xs text-foreground-muted uppercase tracking-wide">{item.label}</p>
                <p className="text-sm text-foreground font-medium">{item.value}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Right Form */}
      <div className="bg-white border border-border rounded-lg p-6 shadow-card">
        <h2 className="text-lg font-heading font-semibold text-foreground mb-4">Send us a Message</h2>
        <p className="text-sm text-foreground-muted mb-4">
          This opens your own email app with the message addressed to us — nothing is sent until
          you press send there. You can also write to us directly at {SUPPORT_EMAIL}.
        </p>
        {opened && (
          <div className="p-4 mb-4 bg-success-light border border-success/20 rounded-md text-success text-sm">
            Your email app should have opened with your message ready to send. If it did not, email
            us at {SUPPORT_EMAIL} instead.
          </div>
        )}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-xs font-medium text-foreground-muted mb-1">Name</label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="input-base"
                placeholder="Your name"
              />
              {errors.name && <p className="text-xs text-danger mt-1">{errors.name}</p>}
            </div>
            <div>
              <label className="block text-xs font-medium text-foreground-muted mb-1">Email</label>
              <input
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                className="input-base"
                placeholder="you@example.com"
              />
              {errors.email && <p className="text-xs text-danger mt-1">{errors.email}</p>}
            </div>
            <div>
              <label className="block text-xs font-medium text-foreground-muted mb-1">Subject</label>
              <input
                type="text"
                value={formData.subject}
                onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
                className="input-base"
                placeholder="How can we help?"
              />
              {errors.subject && <p className="text-xs text-danger mt-1">{errors.subject}</p>}
            </div>
            <div>
              <label className="block text-xs font-medium text-foreground-muted mb-1">Message</label>
              <textarea
                rows={5}
                value={formData.message}
                onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                className="input-base resize-none"
                placeholder="Tell us more about your inquiry..."
              />
              {errors.message && <p className="text-xs text-danger mt-1">{errors.message}</p>}
            </div>
            <button
              type="submit"
              className="btn-primary w-full py-2.5 text-sm flex items-center justify-center gap-2 disabled:opacity-60"
            >
              <Send className="w-4 h-4" />
              Open in your email app
            </button>
          </form>
      </div>
    </div>
  );
}
