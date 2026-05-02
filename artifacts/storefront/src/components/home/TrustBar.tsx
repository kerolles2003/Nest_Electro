import { Truck, RotateCcw, ShieldCheck, Headphones, CreditCard } from 'lucide-react';

export function TrustBar() {
  const items = [
    {
      icon: Truck,
      title: 'Fast Delivery',
      sub: 'Cairo & Alexandria',
    },
    {
      icon: RotateCcw,
      title: 'Easy Returns',
      sub: '14-day return policy',
    },
    {
      icon: ShieldCheck,
      title: 'Money Back',
      sub: '100% guaranteed',
    },
    {
      icon: Headphones,
      title: '24/7 Support',
      sub: 'Engineer-led help',
    },
    {
      icon: CreditCard,
      title: 'Cash on Delivery',
      sub: 'No card required',
    },
  ];

  return (
    <section className="bg-[#0D0625]">
      <div className="container-nest">
        <div className="grid grid-cols-2 md:grid-cols-5 divide-x divide-white/10">
          {items.map((item, i) => (
            <div key={i} className="flex items-center gap-3 px-4 py-4 md:py-5">
              <div className="w-9 h-9 rounded-full bg-white/5 border border-white/10 flex items-center justify-center flex-shrink-0">
                <item.icon className="w-4 h-4 text-[#E14A5C]" strokeWidth={1.5} />
              </div>
              <div className="min-w-0">
                <p className="text-[13px] font-semibold text-white leading-tight">{item.title}</p>
                <p className="text-[11px] text-white/40 leading-tight mt-0.5">{item.sub}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
