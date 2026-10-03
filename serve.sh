#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
bundle exec jekyll serve --port 4000 --livereload "$@"
