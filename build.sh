#!/usr/bin/env bash
# Build the static site and package its deployment artifact.
set -euo pipefail
cd "$(dirname "$0")"

bundle exec rake build
