import { readFile, readdir } from "node:fs/promises";
import stylelint from "stylelint";

const files = ["css/main.scss", ...(await readdir("_sass")).filter((name) => name.endsWith(".scss")).map((name) => `_sass/${name}`)];
let failed = false;
for (const file of files) {
  // Replace Jekyll front matter with blank lines to preserve diagnostic locations.
  const source = (await readFile(file, "utf8")).replace(/^---\r?\n[\s\S]*?\r?\n---\r?\n/, (frontMatter) => frontMatter.replace(/[^\r\n]/g, ""));
  const result = await stylelint.lint({ code: source, codeFilename: file, formatter: "string" });
  if (result.report) process.stdout.write(result.report);
  failed ||= result.errored;
}
if (failed) process.exitCode = 1;
