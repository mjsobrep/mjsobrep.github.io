# mjsStaticSite

My personal website, built with Jekyll. Source changes target `deploy`; the generated site is published to `master`.

## Setup

Install the Ruby version in `.ruby-version` and the Node version in `.node-version` using your preferred version managers. With rbenv, run `rbenv install` in this directory rather than changing your global Ruby version.

```sh
gem install bundler -v 4.0.22
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

This runs Ruby linting, Markdown and SCSS linting, Minitest tests, a strict Jekyll build, offline checks of generated internal links and assets, Jekyll diagnostics, and validation of generated CSS values. GitHub Actions runs the same command on every pull request, including stacked PRs, and before uploading a build for deployment.

Individual commands are `bundle exec rake lint`, `bundle exec rake test`, and `bundle exec rake verify`. Linters use a small correctness-focused ruleset. Markdown linting covers this README and new documentation under `docs/`; historical posts retain their existing formatting. Missing image alt text and external URLs are outside the initial link-checking baseline.

Tag URLs use lowercase slugs, and case variants share one page containing all matching posts. GitHub Pages' 404 page redirects legacy tag URLs to their new locations when JavaScript is enabled. HTTPS enforcement is deferred for historical external URLs.

Two historical content defects retain exact HTMLProofer exceptions: the Git guide's unescaped command placeholder excludes its generated page, and the guitar project's Windows-style PDF URL is ignored. Correcting those posts is a separate content change.

Lint configuration lives in `.rubocop.yml` and `package.json`; Rake coordinates the checks. The lockfiles and runtime version files make local installs match CI. `bin/check` and `serve.sh` provide short commands, and `test/` contains filter, tag, and publication regression tests.

## Deployment and dependency updates

GitHub Actions validates the source, uploads the checked artifact, and publishes it to `master` when changes reach `deploy`. Deployment jobs run sequentially. Local commands build and validate without publishing.

The CV is also updated independently on `master`. CI fetches that branch and runs `bin/sync-cv FETCH_HEAD` **before** building and validating, logging its source commit. To reproduce the published CV locally, run `git fetch origin master` followed by `bin/sync-cv origin/master`, or pass the logged commit SHA to `bin/sync-cv`. This updates `otherFiles/MichaelSobrepera.pdf` in your working tree. A fetch or missing PDF fails the build rather than silently publishing an older CV.

Previously, CI replaced the PDF in `_site` after validation and ignored errors when checking it out from `master`. The checks therefore did not cover the PDF actually uploaded, and a missing file could silently retain the source branch's older copy. Syncing first makes the published PDF a checked build input.

`bin/publish-site` checks that the artifact contains that exact CV and that `master` still points to its source commit. It creates a descendant of that commit and pushes with an explicit Git lease, so an update during either the build or publication cannot be overwritten. If `master` changes, use **Re-run all jobs** on the failed deployment to sync and validate the current CV; rerunning only the deploy job retains the stale artifact. Deployment starts on pushes to `deploy`. There is no manual dispatch trigger because workflows are excluded from the default branch, `master`.

Sass is the source format for the site's CSS. The existing `_sass/` files hold typography, page layout, colors, and code highlighting; `css/main.scss` loads them and Jekyll compiles them into `/css/main.css`. The new `_settings.scss` moves the existing font, color, spacing, and responsive settings out of `css/main.scss` so each module can load them explicitly. In particular, the syntax-highlighting module loads `base` to reuse its `%vertical-rhythm` spacing rule.

Jekyll Sass Converter 2 used the retired LibSass compiler. Converter 3 uses supported Dart Sass; replacing deprecated `@import`, `lighten`, and `darken` with `@use` and `color.adjust` keeps the styles compatible without changing their intended appearance. Ruby 3.4 is also pinned for local/CI consistency. Development files are excluded from the published site.

GitHub Actions use full commit hashes to select exact action code. A version tag, including a full release tag, can be moved; a hash keeps the selected revision stable until a reviewed update. Each `uses:` line includes a readable version comment. This is optional hardening, with longer workflow lines as the tradeoff; Dependabot proposes updates to the pins so they stay maintainable.

Dependabot proposes weekly grouped Ruby, npm, and GitHub Actions updates against `deploy`. Its configuration is copied into the artifact because GitHub reads it from the default branch, `master`; source workflows remain excluded. Runtime versions remain explicit in `.ruby-version` and `.node-version`; review those pins when upgrading runtimes. Use `bundle update` or `npm install` for intentional dependency updates, commit the lockfiles, and run `bin/check` before merging.
