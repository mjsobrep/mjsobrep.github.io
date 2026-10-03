#!/usr/bin/env bash
# Start the Jekyll preview with LiveReload, forwarding extra flags to Jekyll.
set -euo pipefail
cd "$(dirname "$0")"
bundle exec jekyll serve --port 4000 --livereload "$@"
