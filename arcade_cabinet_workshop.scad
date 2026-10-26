/*
 Arcade Cabinet Workshop - v8
 ----------------------------
 Parametric OpenSCAD generator for CNC-cut arcade and virtual pinball cabinets.
 Units: millimeters.

 Every number the builder can change lives in this file so the OpenSCAD
 Customizer (and any front end that writes -D overrides) sees it. The
 geometry, presets, hardware templates, 2D parts, 3D assembly and exporters
 live in lib/. See README.md for the workflow and CHANGELOG.md for history.

 Design rule of v8: the side-panel profile is DERIVED from the stack of cross
 panels (front, kick, fascia, control, lower bezel, screen, upper bezel,
 marquee, top, rear). Every exterior face of the profile is therefore covered
 by a panel, and the assembly checks itself with asserts.
*/

/* [Output] */
// assembly = 3D preview; part = one 2D part for DXF/SVG; wood_sheet / plexi_sheet = overview layouts; bom = cut list in the console; part_list = names available for part_name
output_mode = "assembly"; // [assembly,part,wood_sheet,plexi_sheet,all_sheet,bom,part_list,scene,none]
part_name = "left_side"; // [left_side,right_side,left_side_pockets,right_side_pockets,front_panel,kick_panel,control_fascia,control_panel,lower_bezel,screen_panel,upper_bezel,marquee_frame,marquee_shelf,top_panel,rear_panel,rear_service_door,coin_door,bottom_panel,keyboard_drawer_front,keyboard_drawer_shelf,vesa_mount_panel,vesa_adjust_rail,vpin_apron,vpin_playfield,vpin_rear_deck,vpin_backbox_side,vpin_backbox_front,vpin_backbox_rear,vpin_backbox_top,vpin_backbox_bottom,control_plexi,screen_plexi,marquee_plexi,vpin_backbox_plexi]
show_plexi_preview = true;
show_screen_preview = true;
// Ghost the VESA carrier at its minimum and maximum setback in the assembly view
show_vesa_adjustment_envelope = false;
// Cut the assembly in half along the cabinet centre line to inspect the interior
show_cutaway = false;

/* [Preset] */
// A preset overrides the parameters listed in lib/presets.scad. "custom" uses the values in this file as they are.
design_preset = "custom"; // [custom,tinyarcade_bartop,koenigs_mame,compact_1600,asteroids,classic_80s,we_build_stuff,vpin_731x1308]
// Apply the preset's body dimensions and profile
preset_use_geometry = true;
// Apply the preset's stock thickness
preset_use_material = true;
// Apply the preset's screen size
preset_use_screen = true;
// Apply the preset's player/control layout
preset_use_controls = true;

/* [Cabinet] */
cabinet_style = "standup"; // [standup,bartop,vpin,vpin_bartop]
// Sheet stock thickness. Any positive decimal is accepted (18.25, 19.05, 15 ...)
material_thickness = 18.0;
plexi_thickness = 3.0;
// Router bit diameter, used for inside-corner radii and dogbone relief
tool_diameter = 6.35;
// 0 = automatic from the screen width and player count
cabinet_width = 0;
// 0 = automatic (650 standup, 470 bartop, screen-driven for pinball)
cabinet_depth = 0;
// 0 = automatic from the screen and head. A larger value adds height to the upper bezel.
cabinet_height = 0;
// Height of the control panel's front top edge above the floor (standup) or the bar (bartop)
standup_control_height = 920;
bartop_control_height = 185;
// How far the control panel projects in front of the lower front panel
standup_control_overhang = 80;
bartop_control_overhang = 45;
// Cross panels are set in from the side-panel edge by this much. Gives a T-molding reveal and keeps tab slots inside the side panel. Required > 0 for tab_slot joinery.
panel_inset = 0;
// The bottom panel sits this far above the floor so the side panels act as feet
bottom_lift = 18;
// Rounding applied to the convex corners of the side panels
side_corner_radius = 10; // [0:1:40]

/* [Screen] */
// Visible screen (active area) dimensions, landscape as the manufacturer lists them
screen_width = 531;
screen_height = 299;
// auto = portrait for pinball, landscape for arcade
screen_orientation = "auto"; // [auto,landscape,portrait]
// Added to every edge of the screen opening
screen_cutout_clearance = 2.0;
screen_corner_radius = 4;
// Minimum bezel border beside the screen (used for automatic cabinet width)
screen_side_margin = 45;
// Bezel panel border above and below the screen; sets the screen panel length
screen_top_bottom_margin = 45;
// Degrees from vertical. Positive leans the TOP of the screen away from the player.
screen_recline_angle = 8; // [0:1:25]
// Horizontal gap between the rear edge of the control panel and the lower edge of the screen panel
control_to_screen_clearance = 30;
// Vertical rise from the rear edge of the control panel to the lower edge of the screen panel
screen_gap_above_control = 58;
// true = cut a window in the screen plexi; false = full clear overlay
monitor_plexi_window = false;
// Plexi sheets are cut this much smaller than the opening on every edge so they drop in
plexi_edge_inset = 1.0;

/* [Head and marquee] */
marquee_mode = "auto"; // [auto,on,off]
standup_marquee_height = 180;
bartop_marquee_height = 110;
// How far the marquee face sits in front of the top of the screen panel
marquee_forward_projection = 95;
// Vertical rise of the upper bezel from the top of the screen panel to the underside of the marquee
standup_neck_rise = 150;
bartop_neck_rise = 60;
// Border of the wooden marquee frame around the lit window
marquee_frame_border = 25;
// Horizontal shelf behind the bottom of the marquee (light box floor / retainer support). 0 disables.
marquee_shelf_depth = 150;
// Without a marquee (viewlix style) the top panel still projects this far in front of the screen top
top_forward_projection = 40;
// Speakers are cut into the upper bezel panel (facing the player)
speaker_count = 2; // [0:1:4]
speaker_cutout_diameter = 76;
speaker_spacing = 260;

/* [Front, kick and access] */
// Vertical fascia under the front edge of the control panel (start/coin buttons live here)
control_fascia_height = 95;
// Fascia height used by bartop styles (shorter, the whole front is only ~185 mm)
bartop_control_fascia_height = 60;
// Vertical drop of the angled kick panel between the fascia and the lower front panel. 0 = vertical front.
kick_drop = 80;
coin_door_enabled = false;
coin_door_width = 200;
coin_door_height = 280;
coin_door_bottom_z = 300;
coin_door_clearance = 2;
coin_door_button_count = 2;
coin_door_button_diameter = 24;
keyboard_drawer_enabled = false;
keyboard_drawer_width = 520;
keyboard_drawer_height = 90;
keyboard_drawer_bottom_z = 650;
keyboard_drawer_depth = 360;
keyboard_drawer_clearance = 2;
rear_service_door_enabled = true;
rear_service_door_width = 420;
rear_service_door_height = 800;
rear_service_door_bottom_z = 150;
rear_service_door_clearance = 2;
rear_service_door_mount_hole_diameter = 6;
rear_service_door_vent_holes = 4;
rear_service_door_vent_diameter = 38;
// Rows of ventilation holes in the rear panel above the service door
rear_vent_rows = 2; // [0:1:6]
rear_vent_hole_diameter = 12;
rear_vent_hole_pitch = 24;
// Power inlet / cable pass-through in the lower rear panel. 0 disables.
rear_cable_hole_diameter = 40;
// Leveler / caster bolt holes in the bottom panel. 0 disables.
leveler_hole_diameter = 10;
leveler_hole_inset = 50;

/* [Players and controls] */
players = 2; // [1,2]
buttons_per_player = 6; // [4:1:8]
include_joysticks = true;
// grid = two straight rows, staggered half a pitch; arc = rows on a gentle arc (Vewlix style)
button_layout = "arc"; // [grid,arc]
button_type = "japanese_30"; // [japanese_30,japanese_24,american_28]
// Centre-to-centre pitch between neighbouring buttons
button_pitch = 38;
button_row_pitch = 36;
// Radius of the arc the button rows follow (arc layout only)
button_arc_radius = 220;
// Distance from the front edge of the control panel to the joystick / button row centre
controls_from_front_edge = 120;
// Joystick centre to the centre of the button cluster
joystick_to_button_cluster = 100;
// Joystick-to-joystick distance for two players
player_spacing = 300;
// Mounting template. custom uses the joystick_* values below.
joystick_template = "sanwa_jlf"; // [sanwa_jlf,happ_competition,custom]
joystick_shaft_hole = 24;
joystick_mount_holes_enabled = true;
joystick_mount_hole_diameter = 4.5;
joystick_mount_spacing_x = 85;
joystick_mount_spacing_y = 40;
trackball_enabled = false;
trackball_template = "u_trak"; // [u_trak,custom]
trackball_cutout_diameter = 82;
trackball_mount_holes_enabled = true;
trackball_mount_hole_diameter = 6;
trackball_mount_spacing = 81.3;
trackball_x_offset = 0;
// Trackball centre as a fraction of the control panel depth from the front edge
trackball_y_fraction = 0.28;
// Start / coin / aux buttons
aux_button_count = 2; // [0:1:8]
aux_button_diameter = 24;
aux_button_spacing = 34;
aux_button_location = "fascia"; // [control,fascia,both]
// Distance from the rear edge of the control panel (control location)
aux_rear_margin = 28;
// Added to every hole in the plexi so hardware flanges pass through
plexi_hole_clearance = 0.6;
// Control panel depth measured along the panel and its upward angle toward the screen
control_panel_depth = 260;
control_panel_angle = 5;

/* [Internal VESA monitor mount] */
vesa_mount_panel_enabled = true;
vesa_mount_style = "adjustable"; // [fixed,adjustable]
// Clear distance from the rear face of the screen panel to the front face of the VESA carrier
vesa_panel_setback = 70;
vesa_pattern_x = 100;
vesa_pattern_y = 100;
vesa_hole_diameter = 5.5;
// 0 = automatic from the VESA pattern
vesa_panel_height = 0;
vesa_panel_edge_margin = 35;
vesa_center_x_offset = 0;
vesa_center_y_offset = 0;
vesa_panel_use_joinery = true;
vesa_adjust_min_setback = 40;
vesa_adjust_max_setback = 120;
vesa_adjust_rail_height = 110;
vesa_adjust_rail_end_margin = 18;
vesa_adjust_bolt_spacing_y = 70;
vesa_adjust_bolt_hole_diameter = 6.5;
vesa_adjust_slot_width = 7;
vesa_adjust_carrier_tab_width = 18;
vesa_adjust_carrier_tab_spacing_y = 28;
vesa_adjust_joinery_clearance = 0.25;
vesa_adjust_joinery_dogbones = true;
vesa_adjust_side_holes_enabled = true;

/* [Joinery] */
// none = plain panels (use cleats); screw = guide holes through the sides into panel edges; tab_slot = tabs on the cross panels and slots in the sides
panel_joinery = "none"; // [none,screw,tab_slot]
joinery_count = 2; // [1:1:5]
joinery_screw_hole_diameter = 4.5;
joinery_tab_width = 40;
// Tab penetration into the side panel. Equal to the material thickness = through tabs (visible on the outside). Less = blind pockets exported as *_pockets parts.
joinery_tab_depth = 18;
joinery_slot_clearance = 0.25;
joinery_dogbone_relief = true;

/* [Virtual pinball] */
vpin_front_body_height = 320;
vpin_rear_body_height = 440;
vpin_bartop_front_height = 170;
vpin_bartop_rear_height = 290;
vpin_leg_height = 640;
vpin_leg_size = 42;
// Horizontal flat at the rear of the body where the backbox sits (= backbox depth)
vpin_rear_step = 220;
// Length of the control apron in front of the playfield, measured along the slope
vpin_front_apron = 180;
vpin_side_screen_margin = 55;
pinball_side_buttons = true;
pinball_flipper_hole_diameter = 30;
pinball_flipper_from_front = 78;
pinball_flipper_from_top = 58;
// Launch button in the front panel (right side) and start button (left side)
pinball_launch_button_diameter = 30;
pinball_start_button_diameter = 24;
// Extra buttons on the apron (nudge, extra ball ...)
vpin_apron_button_count = 0; // [0:1:6]
vpin_backbox_enabled = true;
// Backglass (upper) monitor, visible active area in mm, mounted landscape in the backbox. Together with the playfield screen it sets the automatic cabinet width.
backglass_screen_width = 476;
backglass_screen_height = 268;
// Wood border left and right of the backglass opening, and above it
backglass_side_margin = 30;
backglass_top_margin = 30;
// 0 = cabinet width (widened automatically for the backglass monitor)
vpin_backbox_width = 0;
// 0 = automatic: backglass opening + DMD / speaker zone below it
vpin_backbox_height = 0;
// Front-to-back depth of the backbox. It sits on the rear deck with its back flush with the cabinet rear; deeper than the deck overhangs the playfield glass like a real machine.
vpin_backbox_depth = 220;
vpin_backbox_display_corner_radius = 4;
vpin_backbox_speaker_count = 2;
vpin_backbox_speaker_diameter = 85;
vpin_backbox_speaker_spacing = 470;
vpin_backbox_dmd_enabled = true;
vpin_backbox_dmd_width = 300;
vpin_backbox_dmd_height = 80;
vpin_backbox_plexi_window = false;

/* [Layout] */
// Gap between parts in the sheet overview modes
layout_gap = 25;
// Parts wrap to a new row beyond this width in the sheet overview modes
layout_row_width = 2440;

/* [Hidden] */
$fn = 48;

include <lib/presets.scad>
include <lib/hardware.scad>
include <lib/geometry.scad>
include <lib/joinery.scad>
include <lib/parts2d.scad>
include <lib/assembly.scad>
include <lib/export.scad>
include <lib/scene.scad>

// ---------- Main ----------
if (output_mode == "assembly") assembly();
else if (output_mode == "part") export_named_part(part_name);
else if (output_mode == "wood_sheet") wood_sheet_2d();
else if (output_mode == "plexi_sheet") plexi_sheet_2d();
else if (output_mode == "all_sheet") all_sheet_2d();
else if (output_mode == "scene") print_scene();
else if (output_mode == "bom") print_bom();
else if (output_mode == "part_list") print_part_list();
else if (output_mode == "none") {}
else assert(false, str("Unknown output_mode: ", output_mode));
