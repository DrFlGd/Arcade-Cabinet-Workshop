# Web app

A static, browser-only front end for the generator. OpenSCAD runs in the
browser as WebAssembly, so nothing is uploaded and no server is needed.

- `index.html`, `style.css`: page and layout
- `app.js`: state, form, render pipeline, download, share links
- `params.js`: parses the Customizer parameter block of `arcade_cabinet_workshop.scad`, so the form always matches the generator
- `monitors.js`: common monitor sizes for the screen picker
- `worker.js`: Web Worker that runs OpenSCAD (one fresh instance per run)
- `outlines.js`: splits the `all_sheet` SVG into per-part outlines using the `scene` layout rows
- `viewer.js`: Three.js preview built by extruding each outline and applying the placement matrix from the `scene` output
- `export.js`: zip with DXF (from OpenSCAD) and SVG for every part, sheet layouts, cut list, configuration
- `build.sh`: assembles `_site/` (copies the app, the `.scad` sources, and fetches `openscad-wasm-prebuilt`, `three` and `jszip` from npm)

## Run locally

```sh
web/build.sh _site
python3 -m http.server -d _site 8000
# open http://localhost:8000/
```

## How a render works

Each change runs the generator twice in the worker pool: `output_mode="scene"`
(JSON lines: overall size, cut list, layout rects, 3D placements) and
`output_mode="all_sheet"` (one SVG with every outline). The outlines are
assigned to parts by the layout rects and extruded in Three.js. A full
update takes about a second on a laptop. The download runs one DXF export per
part.

## Deployment

`.github/workflows/pages.yml` builds the site on every push to `main` and
publishes it with GitHub Pages. Set the Pages source to "GitHub Actions" once
in the repository settings.
