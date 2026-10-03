// Capture real browser output and assert the flows shown in each PR demo.
const { chromium } = require('/opt/codex/runtimes/cua/lib/node_modules/playwright-core');
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');

const out = '/workspace/pr-review-evidence';
const versions = {
  base110: { port: 4110, commit: '71b21c9406f815078df33ab13e558a5d27d2ee9c', ruby: '3.2.2' },
  pr111: { port: 4111, commit: 'f0e36ac3183358859d2b45a33b9d8dbca464cd60', ruby: '3.2.2' },
  pr112: { port: 4112, commit: 'b5f33f248c1cd76edb0b0e41a2009f5020e4708b', ruby: '3.4.11' },
};
const base = name => 'http://127.0.0.1:' + versions[name].port;
const manifest = {
  capturedAt: new Date().toISOString(),
  versions,
  viewports: { desktop: { width: 1200, height: 800 }, mobile: { width: 390, height: 844 } },
  limitations: ['External images, scripts, videos, and presentation embeds are blocked; their availability is not tested.',
    'Legacy redirects use JavaScript after the server returns the actual custom 404 page.',
    'The headless embedded PDF viewer is not exercised; the PDF assertion verifies only the real local PDF response and signature.'],
  screenshots: [],
  demos: {},
};

async function offline(page) {
  await page.route('**/*', route => /^http:\/\/127\.0\.0\.1:411[012]\//.test(route.request().url())
    ? route.continue() : route.abort());
}

async function visit(page, version, target) {
  const response = await page.goto(base(version) + target, { waitUntil: 'networkidle' });
  assert.equal(response.status(), 200, target);
  await page.evaluate(() => document.fonts.ready);
}

async function screenshot(browser, version, target, viewport, filename) {
  const context = await browser.newContext({ viewport: manifest.viewports[viewport], reducedMotion: 'reduce' });
  const page = await context.newPage();
  await offline(page);
  await visit(page, version, target);
  await page.screenshot({ path: path.join(out, filename) });
  const details = await page.evaluate(() => ({
    title: document.title,
    heading: document.querySelector('h1')?.textContent.trim(),
    posts: Array.from(document.querySelectorAll('.postBoxTitle')).map(e => e.textContent.trim()),
    styles: Array.from(document.querySelectorAll('.site-header,.wrapper,.bodyWrapper,.post-title,.post-content,.widePP,.pdfBox'))
      .map(e => {
        const r = e.getBoundingClientRect();
        const s = getComputedStyle(e);
        return {
          element: e.tagName + '.' + e.className,
          box: [r.x, r.y, r.width, r.height],
          styles: Object.fromEntries(['fontSize','lineHeight','paddingLeft','paddingRight','marginBottom','color','backgroundColor'].map(k => [k, s[k]])),
        };
      }),
  }));
  manifest.screenshots.push({ filename, version, commit: versions[version].commit, path: target, viewport, ...details });
  await context.close();
  return details;
}

async function demo(browser, version, pr) {
  const directory = path.join(out, pr);
  const context = await browser.newContext({
    viewport: { width: 1200, height: 800 },
    recordVideo: { dir: path.join('/tmp/pr-review-captures', pr + '-video'), size: { width: 1200, height: 800 } },
    reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  await offline(page);
  const failures = [];
  page.on('pageerror', e => failures.push(e.message));
  const steps = [];
  const start = Date.now();
  const mark = text => steps.push({ seconds: (Date.now() - start) / 1000, caption: text });
  const pause = () => page.waitForTimeout(2400);

  mark(pr === 'pr111' ? 'PR #111: homepage navigation after the site fixes' : 'PR #112: homepage navigation after upgrading Ruby and Dart Sass');
  await visit(page, version, '/');
  assert.equal(await page.locator('.site-title').textContent(), 'Michael Sobrepera');
  await pause();

  mark('Open Guides, then follow the Python guide link');
  await page.locator('a.page-link', { hasText: /^Guides$/ }).click();
  await page.waitForLoadState('networkidle');
  assert.equal(new URL(page.url()).pathname, '/guides/');
  await pause();
  await page.locator('a[href="/guides/pythonGuide.html"]').first().click();
  await page.waitForLoadState('networkidle');
  assert.equal(new URL(page.url()).pathname, '/guides/pythonGuide.html');
  assert.equal((await page.locator('h1').first().textContent()).trim(), 'Python');
  mark('Python guide renders; scroll to the command examples');
  const firstCode = page.locator('pre').first();
  if (await firstCode.count()) await firstCode.scrollIntoViewIfNeeded();
  await pause();

  mark('Project navigation works; local PDF response verified (HTTP 200)');
  await visit(page, version, '/projects/intussasist.html');
  const pdfObject = page.locator('object[type="application/pdf"]').first();
  assert.equal(await pdfObject.count(), 1);
  const pdf = pdfObject.getAttribute('data');
  const pdfUrl = new URL(await pdf, page.url()).href;
  const response = await page.request.get(pdfUrl);
  assert.equal(response.status(), 200);
  const bytes = await response.body();
  assert.equal(bytes.subarray(0, 5).toString(), '%PDF-');
  await page.evaluate(() => window.scrollTo(0, 0));
  await pause();

  mark('Legacy /tags/GUI.html redirects to /tags/gui.html, retaining query and fragment');
  const legacyUrl = base(version) + '/tags/GUI.html?source=bookmark#posts';
  const initialResponse = page.waitForResponse(r => r.url() === legacyUrl.split('#')[0]);
  await page.goto(legacyUrl, { waitUntil: 'networkidle' });
  assert.equal((await initialResponse).status(), 404);
  await page.waitForURL(url => url.pathname === '/tags/gui.html');
  const redirected = new URL(page.url());
  assert.equal(redirected.search, '?source=bookmark');
  assert.equal(redirected.hash, '#posts');
  const posts = await page.locator('.postBoxTitle').allTextContents();
  assert.deepEqual(posts, ['Tkinter', 'Cystic Fibrosis Modeling Suite']);
  await pause();

  mark('At 390px, the merged GUI tag page still contains both posts');
  await page.setViewportSize({ width: 390, height: 800 });
  await page.evaluate(() => window.scrollTo(0, 0));
  assert.equal(await page.locator('.postBoxTitle').count(), 2);
  await pause();
  assert.deepEqual(failures, [], 'Page JavaScript errors');

  const video = page.video();
  const seconds = (Date.now() - start) / 1000;
  await context.close();
  await video.saveAs(path.join(directory, 'demo.webm'));
  manifest.demos[pr] = {
    version, commit: versions[version].commit, steps, seconds,
    assertions: ['homepage and guide navigation return HTTP 200', 'Python guide title renders',
      'project local PDF returns HTTP 200 with a %PDF- signature',
      'legacy tag request returns the real custom 404 and then redirects',
      'query string and fragment survive redirect', 'GUI/gui posts merge into two distinct cards',
      'both cards remain at mobile width', 'no page JavaScript errors'],
    pdf: { pathname: new URL(pdfUrl).pathname, bytes: bytes.length },
  };
}

(async () => {
  for (const pr of ['pr111','pr112']) fs.mkdirSync(path.join(out, pr), { recursive: true });
  const browser = await chromium.launch({ executablePath: '/usr/bin/chromium', headless: true, args: ['--no-sandbox'] });
  try {
    const oldTag = await screenshot(browser, 'base110', '/tags/gui.html', 'desktop', 'pr111/tag-desktop-before.png');
    const newTag = await screenshot(browser, 'pr111', '/tags/gui.html', 'desktop', 'pr111/tag-desktop-after.png');
    assert.deepEqual(oldTag.posts, ['Tkinter']);
    assert.deepEqual(newTag.posts, ['Tkinter', 'Cystic Fibrosis Modeling Suite']);
    await screenshot(browser, 'base110', '/projects/intussasist.html', 'mobile', 'pr111/project-mobile-before.png');
    await screenshot(browser, 'pr111', '/projects/intussasist.html', 'mobile', 'pr111/project-mobile-after.png');

    const oldProject = await screenshot(browser, 'pr111', '/projects/intussasist.html', 'desktop', 'pr112/project-desktop-before.png');
    const newProject = await screenshot(browser, 'pr112', '/projects/intussasist.html', 'desktop', 'pr112/project-desktop-after.png');
    const oldHome = await screenshot(browser, 'pr111', '/', 'mobile', 'pr112/home-mobile-before.png');
    const newHome = await screenshot(browser, 'pr112', '/', 'mobile', 'pr112/home-mobile-after.png');
    assert.deepEqual(newProject.styles, oldProject.styles, 'Runtime upgrade preserves project layout and colors');
    assert.deepEqual(newHome.styles, oldHome.styles, 'Runtime upgrade preserves mobile home layout and colors');
    manifest.runtimeComparison = { projectDesktop: 'exact computed geometry and styles match', homeMobile: 'exact computed geometry and styles match' };

    await demo(browser, 'pr111', 'pr111');
    await demo(browser, 'pr112', 'pr112');
    for (const item of manifest.screenshots) {
      item.sha256 = crypto.createHash('sha256').update(fs.readFileSync(path.join(out, item.filename))).digest('hex');
    }
    fs.writeFileSync(path.join(out, 'manifest.json'), JSON.stringify(manifest, null, 2) + '\n');
    console.log('Captured eight before/after screenshots and two verified browser recordings.');
  } finally {
    await browser.close();
  }
})().catch(e => { console.error(e); process.exitCode = 1; });
