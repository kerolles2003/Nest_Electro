/** JSON data for an HTML script context; values round-trip without raw markup. */
export function serializeJsonLd(value: unknown): string {
  return JSON.stringify(value).replace(/</g, '\\u003c');
}

/**
 * Browser-only inert parsing followed by reconstruction, never regex HTML filtering.
 * Only formatting elements and safe links survive; no styles, handlers, embeds,
 * images, custom elements or foreign namespaces are copied to the live document.
 */
export function sanitizeRichHtml(html: string): string {
  const source = document.createElement('template');
  source.innerHTML = html;
  const output = document.createElement('div');
  const allowed = new Set(['p', 'br', 'strong', 'b', 'em', 'i', 'u', 's', 'ul', 'ol', 'li',
    'h2', 'h3', 'h4', 'blockquote', 'pre', 'code', 'a', 'hr']);
  const discard = new Set(['script', 'style', 'iframe', 'object', 'embed', 'template', 'svg', 'math']);
  function copy(node: Node, parent: Node): void {
    if (node.nodeType === Node.TEXT_NODE) {
      parent.appendChild(document.createTextNode(node.textContent ?? ''));
      return;
    }
    if (!(node instanceof HTMLElement) || discard.has(node.localName)) return;
    if (!allowed.has(node.localName)) {
      node.childNodes.forEach(child => copy(child, parent));
      return;
    }
    const clean = document.createElement(node.localName);
    if (node.localName === 'a') {
      const href = node.getAttribute('href');
      if (href) {
        try {
          const url = new URL(href, window.location.origin);
          if (url.protocol === 'https:' || url.protocol === 'http:') clean.setAttribute('href', url.href);
        } catch { /* Invalid links become text-only anchors. */ }
      }
    }
    node.childNodes.forEach(child => copy(child, clean));
    parent.appendChild(clean);
  }
  source.content.childNodes.forEach(node => copy(node, output));
  return output.innerHTML;
}
