const assert = require('node:assert/strict');
const fs = require('node:fs');
const ts = require('typescript');
const { chromium } = require('@playwright/test');
const source = fs.readFileSync('src/lib/safe-content.ts', 'utf8');
const compiled = ts.transpileModule(source, { compilerOptions: { module: ts.ModuleKind.CommonJS } }).outputText;
(async () => {
  const browser = await chromium.launch({ channel: 'chrome', headless: true });
  try {
    const page = await browser.newPage();
    await page.route('**/*', route => route.abort());
    await page.setContent('<div id="target"></div>');
    const results = await page.evaluate(code => {
      const exports = {};
      new Function('exports', code)(exports);
      const payloads = [
        '<script>window.injected=1</script><p><strong>Safe</strong></p>',
        '<img src=x onerror="window.injected=1"><a href="javascript:alert(1)">link</a>',
        '<svg><a onload="window.injected=1">x</a></svg><math><mtext>x</mtext></math>',
        '<p onclick="window.injected=1" style="color:red">safe<br>text</p>',
        '<a href="jav&#x61;script:alert(1)">x</a><iframe srcdoc="<script>alert(1)</script>"></iframe>',
        '<ul><li>One</li></ul><blockquote><em>quote</em></blockquote>',
      ];
      return payloads.map(input => {
        const clean = exports.sanitizeRichHtml(input);
        document.querySelector('#target').innerHTML = clean;
        return { clean, executable: !!document.querySelector('#target script, #target img, #target svg, #target math, #target iframe, #target [onclick], #target [onerror], #target [style]'), injected: !!window.injected };
      }).concat([(() => {
        const input = { name: '</script><script>window.injected=1</script>', url: '<!--<script>', breadcrumb: '<script>alert(1)</script>' };
        const clean = exports.serializeJsonLd(input);
        document.querySelector('#target').innerHTML = '<script type="application/ld+json">'+clean+'</script>';
        return { clean, executable: document.querySelectorAll('#target script').length !== 1 || clean.includes('<'), injected: !!window.injected, roundTrip: JSON.stringify(JSON.parse(clean)) === JSON.stringify(input) };
      })()]);
    }, compiled);
    for (const result of results) { assert.equal(result.executable, false); assert.equal(result.injected, false); }
    assert.match(results[0].clean, /<strong>Safe<\/strong>/);
    assert.match(results[5].clean, /<blockquote><em>quote<\/em><\/blockquote>/);
    assert.equal(results[6].roundTrip, true);
    assert(!results[1].clean.includes('href='));
    assert(!results[4].clean.includes('href='));
    console.log('PASS: 7 real Chromium content regressions; all network requests blocked.');
  } finally { await browser.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });
