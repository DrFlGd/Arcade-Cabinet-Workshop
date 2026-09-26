# Arcade Cabinet Workshop

A parametric **OpenSCAD cabinet generator for CNC-cut arcade and virtual pinball builds**.

The project is designed around a single configurable OpenSCAD source file. You can preview a complete cabinet in 3D, choose a built-in cabinet preset or define your own dimensions, then export individual 2D wood or acrylic parts for CAM.

> **Units:** millimeters. Production dimensions should always be checked against your actual monitor, controls, hardware, and measured sheet thickness before cutting.

## Features

- Stand-up arcade, bartop arcade, full virtual pinball, and bartop virtual pinball cabinet modes.
- Reference-plan presets: `tinyarcade_bartop`, `koenigs_mame`, `compact_1600`, `asteroids`, `classic_80s`, `we_build_stuff`, and `vpin_731x1308`, plus fully custom mode.
- Screen-driven cabinet sizing with configurable visible screen dimensions, bezel margins, cutout clearance, screen rotation, corner radius, and monitor recline angle.
- Configurable control-to-screen clearance so the monitor/bezel does not overhang the control panel.
- One- or two-player arcade control layouts with 4–8 action buttons per player.
- Joystick shaft and mounting holes, trackball/roller-ball opening and mounting holes, auxiliary buttons, and optional admin controls.
- Control-panel fascia, keyboard drawer, coin door, rear service door, horizontal speaker shelf, and front-facing speaker baffle options.
- Marquee, monitor, control-panel, and virtual-pinball acrylic/plexiglass parts.
- Fixed or adjustable VESA monitor mounting. The adjustable version uses a VESA carrier and two slotted CNC-cut side rails for post-assembly depth adjustment.
- Screw-guide or tab/slot panel joinery, including optional dogbone relief for routed slots.
- Decimal material and acrylic thickness inputs such as `18.25` mm plywood and `3.175` mm acrylic.
- Complete virtual-pinball backbox support with display opening, speaker openings, optional DMD opening, rear panel, top/bottom, sides, and plexiglass.
- Individual part export plus overview wood/acrylic sheet modes.

## Requirements

- [OpenSCAD](https://openscad.org/)
- A CAM package capable of importing DXF or SVG for toolpath generation
- CNC router, laser, or other suitable sheet-cutting workflow

The generator creates geometry; **cutter compensation, feeds/speeds, hold-down strategy, and final sheet nesting belong in CAM**.

## Quick start

Open `arcade_cabinet_workshop.scad` in OpenSCAD and edit the parameters near the top of the file.

```scad
design_preset = "custom";
cabinet_style = "standup";   // standup, bartop, vpin, vpin_bartop

material_thickness = 18.25;
plexi_thickness = 3.175;

screen_width = 531;
screen_height = 299;
screen_recline_angle = 8;
control_to_screen_clearance = 30;

players = 2;
buttons_per_player = 6;
trackball_enabled = false;

output_mode = "assembly";
```

Render the assembly first and confirm the cabinet proportions before exporting parts.

## Built-in presets

| Preset | General style | Notes |
| --- | --- | --- |
| `custom` | Free-form | Uses your configured dimensions directly. |
| `tinyarcade_bartop` | Curved bartop | Compact curved monitor/control transition. |
| `koenigs_mame` | MAME upright | Traditional upright derived from the supplied reference plan. |
| `compact_1600` | Compact upright | 1600 mm-class cabinet with a pronounced curved neck. |
| `asteroids` | Large classic upright | Includes speaker baffle, admin area, keyboard drawer, coin door, and rear service door defaults. |
| `classic_80s` | Traditional 1980s upright | Approximate classic proportions where the source drawing lacked readable dimensions. |
| `we_build_stuff` | Angular upright | Strong angular side profile and projected control deck. |
| `vpin_731x1308` | Full virtual pinball | Lower playfield cabinet plus backbox. |

Preset groups can be overridden independently:

```scad
preset_use_plan_geometry = true;
preset_use_plan_material = true;
preset_use_plan_screen = true;
preset_use_plan_controls = true;
```

For example, keep a preset silhouette but use your measured plywood and monitor dimensions by disabling only the relevant preset groups.

## Monitor and VESA mounting

The monitor angle is expressed in degrees from vertical:

```scad
screen_recline_angle = 8;
```

A positive value leans the top of the monitor toward the rear of the cabinet, so the display faces slightly upward.

The control-to-screen spacing is independently adjustable:

```scad
control_to_screen_clearance = 30.0;
```

The internal monitor mount supports fixed and adjustable modes:

```scad
vesa_mount_panel_enabled = true;
vesa_mount_style = "adjustable"; // fixed or adjustable

vesa_pattern_x = 100;
vesa_pattern_y = 100;

vesa_adjust_min_setback = 40;
vesa_adjust_max_setback = 120;
vesa_panel_setback = 70;          // assembly preview position
```

In adjustable mode, cut one VESA carrier and **two** `vesa_adjust_rail` parts. The slotted rails allow the display depth to be tuned after the cabinet is assembled.

## Player controls

```scad
players = 2;              // 1 or 2
buttons_per_player = 6;   // 4 through 8
include_joysticks = true;

trackball_enabled = true;
aux_button_count = 4;
aux_button_location = "front"; // control, front, or both
```

Joystick mounting-hole spacing, action-button spacing, trackball cutout diameter, mount-hole patterns, and auxiliary-button sizes are all parameterized.

## Joinery

Choose plain panels, screw alignment holes, or routed tab-and-slot construction:

```scad
panel_joinery = "tab_slot"; // none, screw, tab_slot

joinery_count = 2;
joinery_tab_width = 38.0;
joinery_tab_depth = 8.0;
joinery_slot_clearance = 0.25;
joinery_dogbone_relief = true;
```

For screw construction, configure `joinery_screw_hole_diameter`. For tab/slot construction, test your real tool, material, and fit on scrap before cutting the cabinet.

## Exporting CNC parts

Use assembly mode for design review:

```scad
output_mode = "assembly";
```

For an individual wood part:

```scad
output_mode = "part";
part_material = "wood";
part_name = "left_side";
```

For acrylic:

```scad
output_mode = "part";
part_material = "plexi";
part_name = "screen_plexi";
```

Then export the 2D geometry from OpenSCAD as DXF or SVG and create the final toolpaths in CAM.

Common wood part names include:

`left_side`, `right_side`, `control_panel`, `control_fascia`, `admin_panel`, `keyboard_drawer_front`, `keyboard_drawer_shelf`, `screen_panel`, `vesa_mount_panel`, `vesa_adjust_rail`, `front_panel`, `rear_panel`, `rear_service_door`, `coin_door`, `bottom_panel`, `top_panel`, `marquee_panel`, `speaker_panel`, `speaker_baffle`, and the virtual-pinball backbox panels.

Common acrylic part names include:

`control_plexi`, `screen_plexi`, `marquee_plexi`, and `vpin_backbox_plexi`.

## CNC workflow notes

1. Enter the measured thickness of the actual stock you will cut.
2. Set the real monitor opening and VESA pattern from the manufacturer's drawing.
3. Confirm control hardware dimensions, especially joystick and trackball mounting patterns.
4. Preview the full assembly in OpenSCAD and inspect clearances.
5. Export one production part at a time as DXF/SVG.
6. Apply inside/outside cutter compensation, tabs, feeds/speeds, and sheet nesting in CAM.
7. Test tab/slot fit and critical hardware holes in scrap material before committing a full sheet.

## Important manufacturing checks

Reference-plan presets are intended as useful starting points, not substitutes for measuring your hardware. Before machining, verify monitor body depth and connector clearance, VESA spacing, button and joystick dimensions, trackball geometry, hinges/slides/door hardware, ventilation requirements, material thickness, router diameter, and your CAM compensation strategy.

## Current source version

The repository currently contains the v7 generator developed through the Arcade Cabinet Workshop design iterations.
