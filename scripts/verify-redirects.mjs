import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { runInNewContext } from "node:vm";

const html = await readFile("_site/404.html", "utf8");
const script = html.match(/<script id="legacy-tag-redirects">([\s\S]*?)<\/script>/)?.[1];
assert.ok(script, "The generated 404 page must include legacy tag redirects");

const cases = [
  ["/tags/Python.html", "/tags/python.html?source=bookmark#posts"],
  ["/tags/GUI.html", "/tags/gui.html?source=bookmark#posts"],
  ["/tags/Kennesaw%20Mountain.html", "/tags/kennesaw-mountain.html?source=bookmark#posts"],
  ["/tags/python.html", undefined],
  ["/tags/unknown.html", undefined],
  ["/tags/%invalid.html", undefined],
  ["/unknown.html", undefined],
];
for (const [pathname, expected] of cases) {
  let redirectedTo;
  const window = { location: {
    pathname, search: "?source=bookmark", hash: "#posts",
    replace: (destination) => { redirectedTo = destination; },
  } };
  runInNewContext(script, { window });
  assert.equal(redirectedTo, expected, pathname);
}
console.log(`Verified ${cases.length} legacy tag redirect cases.`);
