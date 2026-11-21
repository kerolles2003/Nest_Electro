// Loaded only by the isolated CSP runtime test/build command, never by the app.
const allowed = new Set(['127.0.0.1', 'localhost', '[::1]', '::1']);
function check(input) {
  const host = typeof input === 'string' || input instanceof URL
    ? new URL(input).hostname : input.hostname ?? input.host ?? 'localhost';
  if (!allowed.has(host)) throw new Error('CSP test blocked non-loopback network request');
}
const originalFetch = globalThis.fetch;
globalThis.fetch = (input, ...args) => { check(input instanceof Request ? input.url : input); return originalFetch(input, ...args); };
for (const name of ['node:http', 'node:https']) {
  const module = require(name);
  for (const method of ['request', 'get']) {
    const original = module[method];
    module[method] = function(input, ...args) { check(input); return original.call(this, input, ...args); };
  }
}
