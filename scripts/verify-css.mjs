import stylelint from "stylelint";

const result = await stylelint.lint({
  files: "_site/css/main.css",
  config: {
    rules: { "declaration-property-value-no-unknown": true },
  },
  formatter: "string",
});
if (result.report) process.stdout.write(result.report);
if (result.errored) process.exitCode = 1;
