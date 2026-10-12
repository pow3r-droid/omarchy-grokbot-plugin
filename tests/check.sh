#!/usr/bin/env bash
# Static checks: manifest JSON valid, entry point exists, no third-party logos.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -c 'import json;m=json.load(open("manifest.json"));assert m["kinds"]==["bar-widget"];import os;assert os.path.exists(m["entryPoints"]["barWidget"])'
! grep -RniE 'xai-logo|spacex-logo|x\.com/logo' --exclude-dir=.git --exclude-dir=tests . 
grep -q 'not affiliated with or endorsed by xAI, SpaceX, or Omarchy' README.md
if command -v omarchy >/dev/null; then omarchy plugin validate .; fi
echo OK
