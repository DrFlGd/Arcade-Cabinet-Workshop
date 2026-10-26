#!/usr/bin/env bash
# Renders every preset in every output mode and every part, and fails on any
# OpenSCAD WARNING, ERROR or assertion. Usage: tests/render_all.sh [outdir]
set -u
cd "$(dirname "$0")/.."
OUT=${1:-/tmp/acw-render}; mkdir -p "$OUT"
SCAD=arcade_cabinet_workshop.scad
PRESETS="custom tinyarcade_bartop koenigs_mame compact_1600 asteroids classic_80s we_build_stuff vpin_731x1308"
STYLES='cabinet_style="bartop" cabinet_style="vpin";backglass_screen_width=708;backglass_screen_height=398 cabinet_style="vpin" cabinet_style="vpin_bartop" panel_joinery="tab_slot";panel_inset=12 panel_joinery="screw" marquee_mode="off" players=1;trackball_enabled=true panel_joinery="tab_slot";panel_inset=12;joinery_tab_depth=8 vesa_mount_style="fixed"'
fail=0
run() { # name, extra -D args...
  local name=$1; shift
  local log; log=$(openscad -o "$OUT/$name.echo" --export-format=echo "$@" "$SCAD" 2>&1; cat "$OUT/$name.echo" 2>/dev/null)   # echo export writes the console into the file
  if echo "$log" | grep -qiE 'WARNING|ERROR|assert'; then echo "FAIL $name"; echo "$log" | grep -iE 'WARNING|ERROR|assert' | head -5; fail=1; else echo "ok   $name"; fi
}
for p in $PRESETS; do
  for m in assembly wood_sheet plexi_sheet all_sheet scene bom part_list; do run "${p}_${m}" -D "design_preset=\"$p\"" -D "output_mode=\"$m\""; done
  # every part listed for this preset
  parts=$(grep -oE '^ECHO: "  [a-z_]+' "$OUT/${p}_part_list.echo" | awk '{print $3}')
  for part in $parts; do run "${p}_part_${part}" -D "design_preset=\"$p\"" -D 'output_mode="part"' -D "part_name=\"$part\""; done
done
for s in $STYLES; do
  args=(); IFS=';' read -ra kv <<< "$s"; for e in "${kv[@]}"; do args+=(-D "$e"); done
  run "custom_$(echo "$s" | tr -c 'a-z0-9' '_')" "${args[@]}" -D 'output_mode="assembly"'
  run "custom_$(echo "$s" | tr -c 'a-z0-9' '_')_sheet" "${args[@]}" -D 'output_mode="wood_sheet"'
done
exit $fail
