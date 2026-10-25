#!/usr/bin/env bash
# Assembles the static site for GitHub Pages (or a local test server).
#   web/build.sh [outdir]      default outdir: _site
# Needs node/npm once to fetch the OpenSCAD WebAssembly build.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=${1:-_site}
WASM_PKG=${WASM_PKG:-openscad-wasm-prebuilt@1.2.0}
rm -rf "$OUT"; mkdir -p "$OUT/scad/lib" "$OUT/vendor" "$OUT/renders"
cp web/index.html web/*.js web/style.css "$OUT/"
cp arcade_cabinet_workshop.scad "$OUT/scad/"
cp lib/*.scad "$OUT/scad/lib/"
( cd "$OUT/scad" && { printf '['; first=1; for f in arcade_cabinet_workshop.scad lib/*.scad; do [ $first = 1 ] || printf ','; printf '"%s"' "$f"; first=0; done; printf ']'; } > manifest.json )
cp docs/renders/*.png "$OUT/renders/" 2>/dev/null || true
tmp=$(mktemp -d)
( cd "$tmp" && npm pack "$WASM_PKG" --silent >/dev/null && tar xzf ./*.tgz )
cp "$tmp/package/dist/openscad.js" "$OUT/vendor/openscad.js"
cp "$tmp/package/COPYING" "$OUT/vendor/OPENSCAD-WASM-LICENSE" 2>/dev/null || true
( cd "$tmp" && rm -rf package ./*.tgz && npm pack three@0.160.0 --silent >/dev/null && tar xzf ./*.tgz )
mkdir -p "$OUT/vendor/three/addons/controls"
cp "$tmp/package/build/three.module.js" "$OUT/vendor/three/three.module.js"
cp "$tmp/package/examples/jsm/controls/OrbitControls.js" "$OUT/vendor/three/addons/controls/OrbitControls.js"
cp "$tmp/package/LICENSE" "$OUT/vendor/three/LICENSE"
( cd "$tmp" && rm -rf package ./*.tgz && npm pack jszip@3.10.1 --silent >/dev/null && tar xzf ./*.tgz )
cp "$tmp/package/dist/jszip.min.js" "$OUT/vendor/jszip.min.js"
cp "$tmp/package/LICENSE.markdown" "$OUT/vendor/JSZIP-LICENSE" 2>/dev/null || true
rm -rf "$tmp"
touch "$OUT/.nojekyll"
echo "site assembled in $OUT"
