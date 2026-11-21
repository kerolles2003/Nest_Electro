'use client';

import { useEffect, useRef } from 'react';
import { sanitizeRichHtml } from '@/lib/safe-content';

export function BlogContent({ html }: { html: string }) {
  const container = useRef<HTMLDivElement>(null);
  useEffect(() => {
    // Server and initial client render are both empty. Untrusted HTML never reaches
    // a live element before inert parsing and allow-list reconstruction.
    if (container.current) container.current.innerHTML = sanitizeRichHtml(html);
  }, [html]);
  return <div className="blog-prose" ref={container} />;
}
