#!/usr/bin/env bash
# Rewrites every `style.css?v=...` reference in the repo's HTML files to use
# the current HEAD's short SHA. Run as the last step before opening a PR or
# pushing the last commit of an existing PR, then commit the bump.
#
# Idempotent: re-running with the same HEAD produces no diff.

set -euo pipefail

cd "$(dirname "$0")/.."

SHA=$(git rev-parse --short HEAD)

# Match both bumped (style.css?v=...) and un-bumped (style.css) references.
# Use a portable sed invocation that works on both GNU and BSD sed.
if sed --version >/dev/null 2>&1; then
  # GNU sed
  sed -i -E "s|href=\"style\\.css(\\?v=[^\"]*)?\"|href=\"style.css?v=$SHA\"|g" *.html
else
  # BSD sed (macOS)
  sed -i '' -E "s|href=\"style\\.css(\\?v=[^\"]*)?\"|href=\"style.css?v=$SHA\"|g" *.html
fi

echo "Bumped style.css cache key to ?v=$SHA"
