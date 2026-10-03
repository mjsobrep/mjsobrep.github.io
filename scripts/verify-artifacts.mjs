import assert from "node:assert/strict";
import { existsSync } from "node:fs";
import { readFile } from "node:fs/promises";

const developmentPaths = [
  "vendor", "node_modules", "bin", "scripts", "test", "docs", "helper_scripts",
  "README.md", "LICENSE", "Rakefile", "Gemfile", "Gemfile.lock",
  "package.json", "package-lock.json", "build.sh", "deploy.sh", ".travis.yml",
];
for (const path of developmentPaths) {
  assert.equal(existsSync(`_site/${path}`), false, `${path} must not be published`);
}
const cvPath = "otherFiles/MichaelSobrepera.pdf";
const source = await readFile(cvPath);
const published = await readFile(`_site/${cvPath}`);
assert.equal(source.subarray(0, 5).toString(), "%PDF-", "The CV must be a PDF");
assert.deepEqual(published, source, "The published CV must match the validated source");
console.log("Verified development files are excluded and the published CV matches its source.");
assert.deepEqual(
  await readFile("_site/.github/dependabot.yml"),
  await readFile(".github/dependabot.yml"),
  "Dependabot configuration must reach the default branch",
);
assert.equal(existsSync("_site/.github/workflows"), false, "Source workflows must not be published");
