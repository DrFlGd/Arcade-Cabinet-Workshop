# Changelog

## v8.1 (2026-10-25)

- Web app in `web/`: browser-only configurator with monitor picker, generated parameter form, 3D preview, parts gallery, sheet layout, cut list, zip export (DXF + SVG per part) and shareable links. OpenSCAD runs as WebAssembly in a worker pool.
- Generator: `output_mode = "scene"` (JSON lines with overall size, cut list, layout rects and 3D placement matrices) and `"all_sheet"` (every outline in one drawing) for external viewers.
- GitHub Actions: render tests on every push and pull request; GitHub Pages deployment of the web app from `main`.

## v8 (2026-10-25)

Rewrite of the generator. The v7 file was a single hand-tuned script whose side profile was drawn independently of the panels it had to hold, which left the cabinet open behind the head, the rear panel short, no panels above or below the screen, the fascia hanging below the profile and the pinball playfield running under the backbox.

### Geometry
- Side profile is now derived from the stack of cross panels, so every face is covered and the shell is closed for every preset and style.
- Butt joints are trimmed for stock thickness at convex corners; concave corners are left full length.
- New panels: top, upper bezel, lower bezel, kick panel, marquee frame with window, marquee shelf.
- Screen position is solved from the control panel (`screen_gap_above_control`, `control_to_screen_clearance`), head height from the screen top, neck rise and marquee.
- `cabinet_width/depth/height = 0` means automatic; a larger height adds to the upper bezel instead of distorting the profile.
- Pinball: playfield slope solved from the screen, apron and rear deck; backbox has its own depth (`vpin_backbox_depth`) and sits on the rear deck.
- `panel_inset` for a T-moulding reveal and to keep tab slots inside the side panel.
- Geometry asserts with readable messages (door, drawer and coin door fit, screen fits the body, control panel clears the screen, front panel tall enough).

### Controls and hardware
- Hardware templates for joysticks, trackballs and buttons instead of loose numbers.
- Grid and arc button layouts; aux and admin buttons on the fascia.

### Joinery and export
- Blind tab pockets export as separate `*_pockets` drawings instead of through cuts.
- Dogbone relief offset correctly along the corner diagonal.
- Sheet layouts use a row packer, so parts no longer overlap.
- `bom` and `part_list` output modes print the cut list and the valid part names.
- Part names are the same in the Customizer dropdown, the part list and the BOM.

### Presets
- Presets are a data table (`lib/presets.scad`) grouped as geometry, material, screen and controls, each group switchable.
- `koenigs_mame` keyboard drawer lowered to 520 mm and `asteroids` to 680 mm so the openings fit the front panel.
- `vpin_731x1308` uses a shorter apron and rear step and tighter top/bottom margins so the 49 in screen fits a 1308 mm body.

### Tooling
- `tests/render_all.sh` renders every preset in every mode and every part, and fails on warnings, errors or assertions.
- `tests/view.scad` render wrapper for fixed-camera PNGs.

### Defaults changed
- Stand-up control height 920, overhang 80, recline 8, marquee 180 with 150 neck rise (overall height 1716 at the default 24 in screen).
- Bartop fascia 60 (`bartop_control_fascia_height`) and no kick panel.
- Rear service door is clamped to the rear panel on bartop and pinball bodies.
