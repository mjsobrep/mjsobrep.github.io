# mjsStaticSite

My personal website, built with Jekyll. Source changes target `deploy`; the generated site is published to `master`.

## Setup

Install the Ruby version in `.ruby-version` and the Node version in `.node-version` using your preferred version managers. With rbenv, run `rbenv install` in this directory rather than changing your global Ruby version.

```sh
gem install bundler -v 2.6.9
bundle install
npm ci
```

Both dependency lockfiles are committed. Use `bundle install` and `npm ci` to reproduce the checked-in versions; dependency updates should include the resulting lockfile changes.

## Preview

```sh
./serve.sh
```

Open <http://localhost:4000>. Extra Jekyll flags can be passed through, for example `./serve.sh --drafts`. `bash build.sh` builds without starting a server.

## Check changes

```sh
bin/check
```

This runs Ruby linting, Markdown and SCSS linting, Minitest tests, a strict Jekyll build, offline checks of generated internal links and assets, Jekyll diagnostics, and validation of generated CSS values. GitHub Actions runs the same command before uploading a build for deployment.

Individual commands are `bundle exec rake lint`, `bundle exec rake test`, and `bundle exec rake verify`. Linters use a small correctness-focused ruleset. Markdown linting covers this README and new documentation under `docs/`; historical posts retain their existing formatting. Missing image alt text and external URLs are outside the initial link-checking baseline.

Tag URLs use lowercase slugs, and case variants share one page containing all matching posts. GitHub Pages' 404 page redirects legacy tag URLs to their new locations when JavaScript is enabled. HTTPS enforcement is deferred for historical external URLs.

Lint configuration lives in `.rubocop.yml` and `package.json`; Rake coordinates the checks. The lockfiles and runtime version files make local installs match CI. `bin/check` and `serve.sh` provide short commands, and `test/` contains the filter and tag regression tests.

The current Ruby and Sass versions are retained for the initial tooling baseline; their upgrades are a separate change.
