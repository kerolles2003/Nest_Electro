import { useState, useEffect, useCallback } from 'react';
import { Link } from 'wouter';
import { ChevronLeft, ChevronRight } from 'lucide-react';

interface HeroBannerProps {
  categories: Array<{ id: string; name_en: string; slug: string; children?: Array<{ id: string; name_en: string; slug: string }> }>;
}

const SLIDES = [
  {
    badge: 'New Collection 2025',
    heading: 'Build Your\nNext Big\nProject',
    sub: 'Arduino, ESP32, sensors & 500+ components delivered across Egypt',
    cta: 'Shop Now',
    ctaHref: '/products',
    bg: 'linear-gradient(135deg, #0D0625 0%, #1a1040 60%, #2d1a5e 100%)',
    accent: '#E14A5C',
    img: null,
  },
  {
    badge: 'Hot Deals',
    heading: 'Big Savings\non Top\nBrands',
    sub: 'Up to 30% off on selected Arduino & Raspberry Pi kits. Limited stock!',
    cta: 'View Deals',
    ctaHref: '/products?sort=price_asc',
    bg: 'linear-gradient(135deg, #1a0d20 0%, #2e1040 60%, #441055 100%)',
    accent: '#f59e0b',
    img: null,
  },
  {
    badge: 'Free Delivery',
    heading: 'Fast Cairo\nDelivery on\nAll Orders',
    sub: 'Orders over 500 EGP ship free. Pay cash on delivery, no card needed.',
    cta: 'Start Shopping',
    ctaHref: '/products',
    bg: 'linear-gradient(135deg, #0a1f2e 0%, #103045 60%, #1a4560 100%)',
    accent: '#22c55e',
    img: null,
  },
];

export function HeroBanner({ categories }: HeroBannerProps) {
  const [current, setCurrent] = useState(0);
  const [isAnimating, setIsAnimating] = useState(false);

  const goTo = useCallback((idx: number) => {
    if (isAnimating) return;
    setIsAnimating(true);
    setCurrent(idx);
    setTimeout(() => setIsAnimating(false), 400);
  }, [isAnimating]);

  const prev = useCallback(() => goTo((current - 1 + SLIDES.length) % SLIDES.length), [current, goTo]);
  const next = useCallback(() => goTo((current + 1) % SLIDES.length), [current, goTo]);

  useEffect(() => {
    const t = setInterval(() => {
      setCurrent((c) => (c + 1) % SLIDES.length);
    }, 5000);
    return () => clearInterval(t);
  }, []);

  const slide = SLIDES[current];
  const displayCategories = categories.filter((c) => !c.children || c.children.length === 0 ? true : true).slice(0, 8);

  return (
    <section className="bg-[#f5f5f5]">
      <div className="container-nest py-4">
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_320px] gap-4">

          {/* Left: slider */}
          <div
            className="relative rounded-lg overflow-hidden min-h-[340px] md:min-h-[400px] flex flex-col justify-end"
            style={{ background: slide.bg, transition: 'background 0.4s ease' }}
          >
            {/* Slide content */}
            <div className="relative z-10 p-8 md:p-10 pb-12">
              <span
                className="inline-block text-[11px] font-bold uppercase tracking-widest px-3 py-1 rounded-full mb-4"
                style={{ background: slide.accent + '22', color: slide.accent, border: `1px solid ${slide.accent}44` }}
              >
                {slide.badge}
              </span>
              <h1 className="font-heading font-extrabold text-white text-3xl md:text-4xl lg:text-5xl leading-[1.1] whitespace-pre-line mb-4">
                {slide.heading}
              </h1>
              <p className="text-white/60 text-sm md:text-base max-w-sm mb-7 leading-relaxed">
                {slide.sub}
              </p>
              <Link
                href={slide.ctaHref}
                className="inline-flex items-center gap-2 px-6 py-3 rounded-md text-sm font-bold text-white transition-opacity hover:opacity-90"
                style={{ background: slide.accent }}
              >
                {slide.cta}
                <ChevronRight className="w-4 h-4" />
              </Link>
            </div>

            {/* Decorative circles */}
            <div className="absolute right-0 top-0 w-72 h-72 rounded-full opacity-5 bg-white -translate-y-1/3 translate-x-1/3" />
            <div className="absolute right-16 top-1/4 w-40 h-40 rounded-full opacity-5 bg-white" />

            {/* Prev / Next */}
            <button
              onClick={prev}
              className="absolute left-3 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full bg-white/10 hover:bg-white/25 text-white flex items-center justify-center transition-colors"
              aria-label="Previous slide"
            >
              <ChevronLeft className="w-5 h-5" />
            </button>
            <button
              onClick={next}
              className="absolute right-3 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full bg-white/10 hover:bg-white/25 text-white flex items-center justify-center transition-colors"
              aria-label="Next slide"
            >
              <ChevronRight className="w-5 h-5" />
            </button>

            {/* Dots */}
            <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex items-center gap-1.5">
              {SLIDES.map((_, i) => (
                <button
                  key={i}
                  onClick={() => goTo(i)}
                  aria-label={`Go to slide ${i + 1}`}
                  className={`rounded-full transition-all duration-300 ${i === current ? 'w-5 h-2 bg-white' : 'w-2 h-2 bg-white/40'}`}
                />
              ))}
            </div>
          </div>

          {/* Right column */}
          <div className="flex flex-col gap-3">
            {/* Promo banner */}
            <div className="rounded-lg overflow-hidden bg-[#0D0625] flex items-center justify-between px-5 py-4 min-h-[110px] relative">
              <div>
                <p className="text-[10px] font-bold uppercase tracking-widest text-[#E14A5C] mb-1">Limited Offer</p>
                <p className="font-heading font-bold text-white text-lg leading-snug">Free Shipping<br />on First Order</p>
                <Link href={ROUTES_PLACEHOLDER} className="mt-2 inline-block text-[11px] font-semibold text-[#E14A5C] hover:underline">Shop Now →</Link>
              </div>
              <div className="text-5xl opacity-10">📦</div>
              <div className="absolute bottom-0 right-0 w-24 h-24 rounded-full bg-[#E14A5C] opacity-10 translate-x-1/3 translate-y-1/3" />
            </div>

            {/* Hot categories grid */}
            <div>
              <p className="text-[10px] font-bold uppercase tracking-wider text-[#999] mb-2 px-0.5">Hot Categories</p>
              <div className="grid grid-cols-2 gap-2">
                {displayCategories.slice(0, 8).map((cat) => (
                  <Link
                    key={cat.id}
                    href={`/categories/${cat.slug}`}
                    className="flex items-center gap-2 bg-white border border-[#e8e8e8] rounded-md px-3 py-2.5 text-sm font-medium text-[#333] hover:border-[#E14A5C] hover:text-[#E14A5C] transition-all duration-150 group"
                  >
                    <span className="w-1.5 h-1.5 rounded-full bg-[#E14A5C] opacity-50 group-hover:opacity-100 flex-shrink-0" />
                    <span className="truncate text-[12px]">{cat.name_en}</span>
                  </Link>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

const ROUTES_PLACEHOLDER = '/products';
