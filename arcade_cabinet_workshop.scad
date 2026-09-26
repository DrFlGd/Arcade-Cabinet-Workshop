/*
 Parametric Arcade / Virtual Pinball Cabinet Creator — v7
 -------------------------------------------------------
 Units: millimeters

 Designed for CNC-cut sheet goods and acrylic/plexiglass.

 Major v7 changes:
   - Added selectable reference-plan presets for TinyArcade bartop, Koenigs MAME,
     compact 1600 mm upright, Asteroids/Niels upright, classic 1980s upright,
     We Build Stuff full-size profile, and a 731 x 1308 virtual-pinball layout.
   - Dimensioned values from the supplied drawings are used where legible;
     missing/ambiguous values are intentionally approximated and documented.
   - Added profile-specific side silhouettes, including true sampled curves.
   - Added optional control fascia, admin panel, keyboard drawer, coin door,
     rear service door, and vertical upper speaker baffle.
   - Added a virtual-pinball backbox with display, speaker/DMD openings, acrylic,
     and individually exportable CNC panels.
   - Front/rear assembly previews now render their actual 2D cutouts.

 Retained from v6:
   - True physical control-to-monitor clearance.
   - Full-height flush marquee face matched by the side profile.

 Retained from v5:
   - Added an adjustable VESA sled mode in addition to the original fixed backer.
   - The adjustable sled uses a CNC-cut VESA carrier plus two side rails.
   - Each rail has two elongated depth-adjustment slots; fixed side-wall bolts
     let the whole monitor carrier slide closer to or farther from the bezel.
   - The carrier interlocks with both rails using tab/mortise joints.
   - Minimum/maximum setback, current preview setback, rail dimensions,
     bolt diameter and adjustment-slot width are all parametric.

 Retained from v4:
   - Optional internal VESA monitor-mount panel behind the screen opening.
   - Variable perpendicular setback from the rear face of the bezel/screen panel.
   - Fully parametric VESA X/Y spacing, hole diameter and center offsets.
   - Fixed VESA panels can inherit screw-guide or tab/slot side joinery.

 Retained from v3:
   - Head panels butt together with no default visual gap: marquee,
     speaker shelf, and top cap form one continuous assembly.
   - Optional screw-guide or tab/slot side joinery for cross panels.
   - Sheet thickness accepts arbitrary positive decimal millimeter values.

 Retained from v2:
   - Arcade monitor angle is now explicit and ergonomic:
       screen_recline_angle > 0 means the TOP of the monitor leans AWAY
       from the player, so the screen face points slightly upward.
   - New arcade silhouette presets based on common cabinet proportions:
       "classic"  = full upright with marquee/speaker hood
       "curved"   = rounded bartop / compact cabinet
       "viewlix"  = tall, clean monitor-forward silhouette
       "auto"     = classic for standup, curved for bartop
   - Screen-panel placement is derived from the control deck and the
     requested screen angle instead of hard-coded upper/lower points.
   - Optional speaker panel and speaker cutouts.
   - Aux buttons may be placed on the control deck, front fascia, or both.
   - Improved bartop front-panel sizing and 3D preview alignment.

 Recommended workflow:
   1. Set cabinet_style, arcade_profile, screen size, players and controls.
   2. Use output_mode="assembly" to inspect proportions.
   3. Use output_mode="part" for clean DXF/SVG export per part.
   4. Apply inside/outside cutter compensation in CAM.

 Supported cabinet styles:
   "standup", "bartop", "vpin", "vpin_bartop"
*/

// ---------- Output ----------
output_mode = "assembly"; // [assembly,wood_sheet,plexi_sheet,part]
part_material = "wood";  // [wood,plexi]
part_name = "control_panel"; // [left_side,right_side,control_panel,control_fascia,admin_panel,keyboard_drawer_front,keyboard_drawer_shelf,screen_panel,vesa_mount_panel,vesa_adjust_rail,front_panel,rear_panel,rear_service_door,coin_door,bottom_panel,top_panel,marquee_panel,speaker_panel,speaker_baffle,vpin_backbox_side,vpin_backbox_front,vpin_backbox_rear,vpin_backbox_top,vpin_backbox_bottom,control_plexi,screen_plexi,marquee_plexi,vpin_backbox_plexi]
show_plexi_preview = true;
show_screen_preview = true;
show_screen_normal_preview = false; // small arrow showing the direction the screen faces

// ---------- Reference-plan presets ----------
// Presets provide useful starting geometry from the attached plans. Values that
// were not legible/explicit in a drawing are approximated rather than presented
// as exact reproductions. Set design_preset="custom" for the original free-form mode.
design_preset = "custom"; // [custom,tinyarcade_bartop,koenigs_mame,compact_1600,asteroids,classic_80s,we_build_stuff,vpin_731x1308]

// Apply the plan's overall dimensions/profile, monitor estimate and controls.
// Disable individual groups to keep the profile while using your own values.
preset_use_plan_geometry = true;
preset_use_plan_material = true; // use nominal stock thickness shown/assumed by the reference plan
preset_use_plan_screen = true;
preset_use_plan_controls = true;

// ---------- Cabinet ----------
cabinet_style = "standup"; // [standup,bartop,vpin,vpin_bartop]

// Arcade silhouette preset. "auto" selects classic for standup and curved for bartop.
arcade_profile = "auto"; // [auto,classic,curved,viewlix]

material_thickness = 18.0; // mm; arbitrary positive decimals are supported (e.g. 18.25)
plexi_thickness = 3.0;     // mm; arbitrary positive decimals are supported
tool_diameter = 6.35;      // 1/4 in router bit by default
layout_gap = 25;

// Set to 0 for automatic sizing based on the screen and player count.
cabinet_width = 0;
standup_depth = 650;
bartop_depth = 470;
standup_height = 0; // 0 = automatic
bartop_height = 0;  // 0 = automatic

// Ergonomic control-deck placement.
standup_control_height = 920;
bartop_control_height = 185;
standup_control_overhang = 80;
bartop_control_overhang = 45;

// Outer edge softening for arcade side panels. Set 0 for a sharp polygonal profile.
side_corner_radius = 10; // [0:1:30]

// ---------- Screen / monitor ----------
// Enter the desired visible opening or monitor-face dimensions.
screen_width = 531;
screen_height = 299;
screen_rotate_90 = false;
screen_cutout_clearance = 2.0; // added on every edge
screen_side_margin = 45;
screen_top_bottom_margin = 45;
screen_corner_radius = 4;

// IMPORTANT: degrees from vertical.
// Positive values lean the TOP of the monitor away from the player,
// making the display face slightly upward. 6–12 degrees is a useful range.
screen_recline_angle = 8; // [0:1:20]

// Optional overrides for arcade screen-panel lower edge in side-view coordinates.
// 0 uses ergonomic automatic placement from the control deck.
screen_lower_y_override = 0;
screen_lower_z_override = 0;
screen_gap_above_control = 58;

// Actual side-view clearance between the rear edge of the control/button
// panel and the nearest face of the monitor/bezel panel. The screen-panel
// origin automatically includes the panel-thickness projection caused by
// screen_recline_angle, so this remains a real gap rather than a centerline gap.
control_to_screen_clearance = 30.0;

// If true, screen plexi gets a physical window cutout. Leave false for a full clear overlay.
monitor_plexi_window = false;

// ---------- Internal VESA monitor mount ----------
// A CNC-cut carrier parallel to the screen/bezel panel and located behind it.
vesa_mount_panel_enabled = true;

// "fixed" keeps the original direct-to-side-wall backer.
// "adjustable" adds two CNC side rails so the carrier can slide in depth.
vesa_mount_style = "adjustable"; // [fixed,adjustable]

// Current/preview perpendicular clear distance from the REAR face of the
// screen/bezel panel to the FRONT face of the VESA carrier.
vesa_panel_setback = 70.0;

// VESA hole-center spacing. Examples: 75x75, 100x100, 200x100, 200x200.
// Use the pattern specified by the monitor manufacturer.
vesa_pattern_x = 100.0;
vesa_pattern_y = 100.0;
vesa_hole_diameter = 5.5;

// Mount panel height along the screen plane. 0 = automatic from VESA pattern.
vesa_panel_height = 0;
vesa_panel_edge_margin = 35.0;

// Shift the VESA hole-pattern center relative to the screen-opening center.
// +X moves toward cabinet right; +Y moves toward the top of the screen panel.
vesa_center_x_offset = 0.0;
vesa_center_y_offset = 0.0;

// Fixed-mode only: when true, the VESA backer participates in panel_joinery
// and receives matching side-panel screw guides or tab/slot features.
vesa_panel_use_joinery = true;

// ---------- Adjustable VESA sled ----------
// The current vesa_panel_setback must lie between these two values. The side
// rails provide continuous travel across this range.
vesa_adjust_min_setback = 40.0;
vesa_adjust_max_setback = 120.0;

// Each side rail is a flat CNC part mounted parallel to the cabinet side.
// It interlocks with the VESA carrier and slides on two side-wall bolts.
vesa_adjust_rail_height = 110.0;
vesa_adjust_rail_end_margin = 18.0;
vesa_adjust_bolt_spacing_y = 70.0;
vesa_adjust_bolt_hole_diameter = 6.5;
vesa_adjust_slot_width = 7.0;

// Carrier-to-rail tab/mortise connection. Two tabs per side are used so the
// rail cannot pivot relative to the carrier.
vesa_adjust_carrier_tab_width = 18.0;
vesa_adjust_carrier_tab_spacing_y = 28.0;
vesa_adjust_joinery_clearance = 0.25;
vesa_adjust_joinery_dogbones = true;

// Cut the two fixed bolt holes in each cabinet side panel. Disable this if you
// prefer to locate the rail hardware manually or use an internal bracket.
vesa_adjust_side_holes_enabled = true;

// Optional translucent ghosts at minimum and maximum setback in assembly view.
show_vesa_adjustment_envelope = false;

// ---------- Arcade head / marquee / speaker area ----------
marquee_mode = "auto"; // [auto,on,off]
standup_marquee_height = 145;
bartop_marquee_height = 110;
marquee_forward_projection = 95; // how far the hood projects toward the player from screen top
marquee_depth = 210;
head_panel_gap = 0.0; // 0 = marquee face, speaker shelf and top cap touch with no reveal
marquee_min_gap_above_screen = 60;

speaker_panel_enabled = true;
speaker_panel_depth = 115;
speaker_count = 2; // [0:1:4]
speaker_cutout_diameter = 76;
speaker_spacing = 260;

// Optional front-facing speaker baffle below the marquee. Useful for classic
// upright plans whose speakers face the player rather than downward.
speaker_baffle_enabled = false;
speaker_baffle_height = 140.0;


// ---------- Panel joinery ----------
// Joinery is cut into both side panels and applied to the major cross panels:
// bottom, control deck, top cap, speaker shelf, and vpin playfield.
// "screw" adds through-holes in the side panels aimed at panel edges.
// "tab_slot" adds tabs to cross panels and matching CNC slots in the sides.
panel_joinery = "none"; // [none,screw,tab_slot]
joinery_count = 2; // [1:1:4]
joinery_screw_hole_diameter = 4.5;
joinery_tab_width = 38.0;
joinery_tab_depth = 8.0; // penetration into each side panel; must be <= material_thickness
joinery_slot_clearance = 0.25; // total added width/length around slots
joinery_dogbone_relief = true; // router-bit corner relief for tab slots

// ---------- Players / arcade controls ----------
players = 2;               // [1,2]
buttons_per_player = 6;    // [4:1:8]
include_joysticks = true;
action_button_diameter = 30;
button_spacing_x = 38;
button_spacing_y = 36;
player_spacing = 290;
joystick_to_button_cluster = 92;
joystick_shaft_hole = 24;
joystick_mount_holes_enabled = true;
joystick_mount_hole_diameter = 5;
joystick_mount_spacing_x = 40;
joystick_mount_spacing_y = 40;

// Roller-ball / trackball
trackball_enabled = false;
trackball_cutout_diameter = 82;
trackball_mount_holes_enabled = true;
trackball_mount_hole_diameter = 5;
trackball_mount_spacing_x = 70;
trackball_mount_spacing_y = 70;
trackball_x_offset = 0;
trackball_y_fraction = 0.25;

// Aux buttons
aux_button_count = 3;      // [0:1:8]
aux_button_diameter = 24;
aux_button_spacing = 34;
aux_rear_margin = 28;
aux_button_location = "control"; // [control,front,both]
aux_front_height_fraction = 0.58;

// Control panel geometry
arcade_control_panel_depth = 260;
vpin_control_panel_depth = 170;
control_panel_angle = 5; // degrees upward toward the back

// Optional control fascia at the front edge of the button deck. This is the
// natural home for front-facing start/coin/admin buttons on many cabinets.
control_fascia_enabled = true;
control_fascia_height = 95.0;

// Optional vertical panel between the control deck and monitor area.
admin_panel_enabled = false;
admin_panel_height = 90.0;
admin_button_count = 0;
admin_button_diameter = 24.0;
admin_button_spacing = 34.0;

// Optional keyboard drawer representation: a front face cut into the lower
// front panel plus a horizontal shelf. These are simple CNC panels, not slides.
keyboard_drawer_enabled = false;
keyboard_drawer_width = 520.0;
keyboard_drawer_height = 90.0;
keyboard_drawer_bottom_z = 760.0;
keyboard_drawer_depth = 360.0;
keyboard_drawer_clearance = 2.0;

// Plexi clearances for buttons / joystick / trackball / mounting screws.
plexi_hole_clearance = 0.6;
plexi_edge_inset = 0.0;

// ---------- Virtual pinball ----------
vpin_front_body_height = 310;
vpin_rear_body_height = 430;
vpin_bartop_front_height = 170;
vpin_bartop_rear_height = 290;
vpin_leg_height = 650;
vpin_side_screen_margin = 55;
vpin_front_apron = 190;
vpin_rear_apron = 85;
vpin_depth_extra = 320;
pinball_side_buttons = true;
pinball_flipper_hole_diameter = 30;
pinball_flipper_from_front = 78;
pinball_flipper_from_top = 58;

// ---------- Optional front/rear access panels ----------
coin_button_enabled = false;
coin_button_diameter = 30;

coin_door_enabled = false;
coin_door_width = 200.0;
coin_door_height = 280.0;
coin_door_bottom_z = 300.0;
coin_door_clearance = 2.0;
coin_door_button_count = 2;
coin_door_button_diameter = 24.0;

rear_service_door_enabled = false;
rear_service_door_width = 400.0;
rear_service_door_height = 800.0;
rear_service_door_bottom_z = 180.0;
rear_service_door_clearance = 2.0;
rear_service_door_mount_hole_diameter = 6.0;
rear_service_door_vent_holes = 4;
rear_service_door_vent_diameter = 38.0;

pinball_plunger_enabled = false;
pinball_plunger_hole_diameter = 32;

// ---------- Virtual-pinball backbox ----------
vpin_backbox_enabled = false;
vpin_backbox_width = 0; // 0 = cabinet width
vpin_backbox_height = 520.0;
vpin_backbox_depth = 220.0;
vpin_backbox_bottom_gap = 0.0;
vpin_backbox_rear_overhang = 0.0;
vpin_backbox_display_width = 600.0;
vpin_backbox_display_height = 335.0;
vpin_backbox_display_corner_radius = 4.0;
vpin_backbox_speaker_count = 2;
vpin_backbox_speaker_diameter = 85.0;
vpin_backbox_speaker_spacing = 470.0;
vpin_backbox_dmd_enabled = true;
vpin_backbox_dmd_width = 300.0;
vpin_backbox_dmd_height = 80.0;
vpin_backbox_plexi_window = false;

// ---------- Derived values ----------
function preset_active() = design_preset != "custom";
function preset_is(n) = design_preset == n;

// Plan-presets intentionally separate directly visible dimensions from estimates.
// The dimensioned drawings remain the authority; these values are generator-ready
// starting points, not claims of manufacturing-exact reproduction.
function active_cabinet_style() = preset_active()
    ? (preset_is("tinyarcade_bartop") ? "bartop" : preset_is("vpin_731x1308") ? "vpin" : "standup")
    : cabinet_style;

function active_material_thickness() = preset_active() && preset_use_plan_material
    ? (preset_is("tinyarcade_bartop") ? 15.0 :
       preset_is("we_build_stuff") ? 19.05 : 18.0)
    : material_thickness;

function preset_cab_width() =
    preset_is("tinyarcade_bartop") ? 500.0 :       // 470 mm inner panels + 2x15 mm sides
    preset_is("koenigs_mame") ? 636.0 :            // ~600 mm inner cross-panels + 18 mm sides
    preset_is("compact_1600") ? 636.0 :
    preset_is("asteroids") ? 736.0 :                // drawing explicitly notes 700 + 18 + 18
    preset_is("classic_80s") ? 650.0 :
    preset_is("we_build_stuff") ? 650.0 :
    preset_is("vpin_731x1308") ? 731.0 : 0;

function preset_body_depth() =
    preset_is("tinyarcade_bartop") ? 420.0 :
    preset_is("koenigs_mame") ? 500.0 :
    preset_is("compact_1600") ? 500.0 :
    preset_is("asteroids") ? 550.0 :                // 650 total incl. ~100 control projection
    preset_is("classic_80s") ? 650.0 :
    preset_is("we_build_stuff") ? 500.0 :           // 50.00 cm body; 59.51 cm incl. control projection
    preset_is("vpin_731x1308") ? 1308.0 : 0;

function preset_body_height() =
    preset_is("tinyarcade_bartop") ? 500.0 :
    preset_is("koenigs_mame") ? 1800.0 :
    preset_is("compact_1600") ? 1600.0 :
    preset_is("asteroids") ? 1892.0 :
    preset_is("classic_80s") ? 1850.0 :
    preset_is("we_build_stuff") ? 1850.0 : 0;

function preset_control_height() =
    preset_is("tinyarcade_bartop") ? 160.0 :
    preset_is("koenigs_mame") ? 820.0 :
    preset_is("compact_1600") ? 718.0 :
    preset_is("asteroids") ? 1050.0 :
    preset_is("classic_80s") ? 930.0 :
    preset_is("we_build_stuff") ? 960.2 : 0;

function preset_control_overhang() =
    preset_is("tinyarcade_bartop") ? 0.0 :
    preset_is("koenigs_mame") ? 100.0 :
    preset_is("compact_1600") ? 80.0 :
    preset_is("asteroids") ? 100.0 :
    preset_is("classic_80s") ? 80.0 :
    preset_is("we_build_stuff") ? 95.1 : 0;

function preset_control_depth() =
    preset_is("tinyarcade_bartop") ? 110.0 :
    preset_is("koenigs_mame") ? 250.0 :
    preset_is("compact_1600") ? 220.0 :
    preset_is("asteroids") ? 251.0 :
    preset_is("classic_80s") ? 250.0 :
    preset_is("we_build_stuff") ? 198.9 :
    preset_is("vpin_731x1308") ? 170.0 : 0;

function preset_control_angle() =
    preset_is("tinyarcade_bartop") ? 10.0 :
    preset_is("koenigs_mame") ? 6.0 :
    preset_is("compact_1600") ? 4.0 :
    preset_is("asteroids") ? 6.0 :
    preset_is("classic_80s") ? 5.0 :
    preset_is("we_build_stuff") ? 5.0 : 5.0;

function preset_screen_w() =
    preset_is("tinyarcade_bartop") ? 305.0 :
    preset_is("koenigs_mame") ? 400.0 :
    preset_is("compact_1600") ? 480.0 :
    preset_is("asteroids") ? 510.0 :              // explicit visible-screen dimension
    preset_is("classic_80s") ? 500.0 :
    preset_is("we_build_stuff") ? 500.0 :
    preset_is("vpin_731x1308") ? 620.0 : 0;

function preset_screen_h() =
    preset_is("tinyarcade_bartop") ? 220.0 :
    preset_is("koenigs_mame") ? 300.0 :
    preset_is("compact_1600") ? 270.0 :
    preset_is("asteroids") ? 290.0 :              // explicit visible-screen dimension
    preset_is("classic_80s") ? 375.0 :
    preset_is("we_build_stuff") ? 375.0 :
    preset_is("vpin_731x1308") ? 1080.0 : 0;

function preset_screen_recline() =
    preset_is("tinyarcade_bartop") ? 12.0 :
    preset_is("koenigs_mame") ? 12.0 :
    preset_is("compact_1600") ? 9.0 :
    preset_is("asteroids") ? 10.0 :
    preset_is("classic_80s") ? 10.0 :
    preset_is("we_build_stuff") ? 10.0 : 8.0;

function preset_screen_tb_margin() =
    preset_is("tinyarcade_bartop") ? 10.0 :
    preset_is("asteroids") ? 50.0 : 45.0;
function preset_screen_side_margin() =
    preset_is("tinyarcade_bartop") ? 35.0 :
    preset_is("asteroids") ? 75.0 : 45.0;
function preset_control_screen_clearance() =
    preset_is("tinyarcade_bartop") ? 18.0 :
    preset_is("we_build_stuff") ? 20.0 : 30.0;
function preset_screen_gap_above_control() =
    preset_is("tinyarcade_bartop") ? 5.0 :
    preset_is("asteroids") ? 55.0 :
    preset_is("we_build_stuff") ? 60.0 : 58.0;

function preset_marquee_h() =
    preset_is("tinyarcade_bartop") ? 62.0 :
    preset_is("koenigs_mame") ? 150.0 :
    preset_is("compact_1600") ? 110.0 :
    preset_is("asteroids") ? 216.0 :
    preset_is("classic_80s") ? 200.0 :
    preset_is("we_build_stuff") ? 224.0 : 145.0;
function preset_marquee_projection() =
    preset_is("tinyarcade_bartop") ? 55.0 :
    preset_is("asteroids") ? 100.0 :
    preset_is("we_build_stuff") ? 80.0 : 95.0;
function preset_marquee_depth() =
    preset_is("tinyarcade_bartop") ? 194.0 :
    preset_is("asteroids") ? 500.0 :
    preset_is("we_build_stuff") ? 500.0 : 210.0;

function active_screen_width() = preset_active() && preset_use_plan_screen ? preset_screen_w() : screen_width;
function active_screen_height() = preset_active() && preset_use_plan_screen ? preset_screen_h() : screen_height;
function active_screen_rotate_90() = preset_active() && preset_use_plan_screen ? false : screen_rotate_90;
function active_screen_recline_angle() = preset_active() && preset_use_plan_geometry ? preset_screen_recline() : screen_recline_angle;
function active_screen_side_margin() = preset_active() && preset_use_plan_geometry ? preset_screen_side_margin() : screen_side_margin;
function active_screen_tb_margin() = preset_active() && preset_use_plan_geometry ? preset_screen_tb_margin() : screen_top_bottom_margin;
function active_control_screen_clearance() = preset_active() && preset_use_plan_geometry ? preset_control_screen_clearance() : control_to_screen_clearance;
function active_screen_gap_above_control() = preset_active() && preset_use_plan_geometry ? preset_screen_gap_above_control() : screen_gap_above_control;
function active_control_panel_angle() = preset_active() && preset_use_plan_geometry ? preset_control_angle() : control_panel_angle;
function active_side_corner_radius() = preset_active() && preset_use_plan_geometry
    ? (preset_is("tinyarcade_bartop") ? 0 : preset_is("we_build_stuff") ? 0 : side_corner_radius)
    : side_corner_radius;

function active_players() = preset_active() && preset_use_plan_controls
    ? (preset_is("tinyarcade_bartop") || preset_is("vpin_731x1308") ? 1 : 2)
    : players;
function active_buttons_per_player() = preset_active() && preset_use_plan_controls ? 6 : buttons_per_player;
function active_include_joysticks() = preset_active() && preset_use_plan_controls ? !preset_is("vpin_731x1308") : include_joysticks;
function active_trackball_enabled() = preset_active() && preset_use_plan_controls ? false : trackball_enabled;
function active_aux_button_count() = preset_active() && preset_use_plan_controls
    ? (preset_is("tinyarcade_bartop") ? 2 : preset_is("vpin_731x1308") ? 0 : 3)
    : aux_button_count;
function active_aux_button_location() = preset_active() && preset_use_plan_controls
    ? (preset_is("tinyarcade_bartop") ? "front" : "control")
    : aux_button_location;

function preset_control_fascia_enabled() = preset_active() && preset_use_plan_geometry
    ? !preset_is("vpin_731x1308") : control_fascia_enabled;
function active_control_fascia_height() = preset_active() && preset_use_plan_geometry
    ? (preset_is("tinyarcade_bartop") ? 70.0 : preset_is("asteroids") ? 150.0 : preset_is("we_build_stuff") ? 110.0 : control_fascia_height)
    : control_fascia_height;
function active_admin_panel_enabled() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") || preset_is("koenigs_mame")) : admin_panel_enabled;
function active_admin_panel_height() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") ? 150.0 : preset_is("koenigs_mame") ? 90.0 : admin_panel_height)
    : admin_panel_height;
function active_keyboard_drawer_enabled() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") || preset_is("koenigs_mame")) : keyboard_drawer_enabled;
function active_keyboard_drawer_width() = min(inner_w()-40, preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") ? 520.0 : 500.0) : keyboard_drawer_width);
function active_keyboard_drawer_height() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") ? 100.0 : 90.0) : keyboard_drawer_height;
function active_keyboard_drawer_bottom_z() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") ? 850.0 : 650.0) : keyboard_drawer_bottom_z;
function active_keyboard_drawer_depth() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") ? 400.0 : 360.0) : keyboard_drawer_depth;

function active_coin_door_enabled() = preset_active() && preset_use_plan_geometry ? preset_is("asteroids") : coin_door_enabled;
function active_coin_door_width() = preset_is("asteroids") && preset_use_plan_geometry ? 200.0 : coin_door_width;
function active_coin_door_height() = preset_is("asteroids") && preset_use_plan_geometry ? 280.0 : coin_door_height;
function active_coin_door_bottom_z() = preset_is("asteroids") && preset_use_plan_geometry ? 470.0 : coin_door_bottom_z;
function active_rear_service_door_enabled() = preset_active() && preset_use_plan_geometry ? preset_is("asteroids") : rear_service_door_enabled;
function active_rear_service_door_width() = preset_is("asteroids") && preset_use_plan_geometry ? 400.0 : rear_service_door_width;
function active_rear_service_door_height() = preset_is("asteroids") && preset_use_plan_geometry ? 1000.0 : rear_service_door_height;
function active_rear_service_door_bottom_z() = preset_is("asteroids") && preset_use_plan_geometry ? 180.0 : rear_service_door_bottom_z;

function active_speaker_baffle_enabled() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") || preset_is("koenigs_mame")) : speaker_baffle_enabled;
function active_speaker_baffle_height() = preset_active() && preset_use_plan_geometry
    ? (preset_is("asteroids") ? 150.0 : 110.0) : speaker_baffle_height;
function active_speaker_shelf_enabled() = preset_active() && preset_use_plan_geometry
    ? !(preset_is("asteroids") || preset_is("koenigs_mame")) : speaker_panel_enabled;

function active_vpin_front_body_h() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 330.0 : vpin_front_body_height;
function active_vpin_rear_body_h() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 470.0 : vpin_rear_body_height;
function active_vpin_bartop_front_h() = vpin_bartop_front_height;
function active_vpin_bartop_rear_h() = vpin_bartop_rear_height;
function active_vpin_leg_height() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 650.0 : vpin_leg_height;
function active_vpin_front_apron() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 180.0 : vpin_front_apron;
function active_vpin_rear_apron() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 70.0 : vpin_rear_apron;
function active_vpin_depth_extra() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 0.0 : vpin_depth_extra;

function active_vpin_backbox_enabled() = is_vpin() && (preset_is("vpin_731x1308") && preset_use_plan_geometry ? true : vpin_backbox_enabled);
function active_vpin_backbox_width() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 731.0 : (vpin_backbox_width > 0 ? vpin_backbox_width : cab_w());
function active_vpin_backbox_height() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 520.0 : vpin_backbox_height;
function active_vpin_backbox_depth() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 220.0 : vpin_backbox_depth;
function active_vpin_backbox_display_w() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 600.0 : vpin_backbox_display_width;
function active_vpin_backbox_display_h() = preset_is("vpin_731x1308") && preset_use_plan_geometry ? 335.0 : vpin_backbox_display_height;
function vpin_backbox_inner_w() = active_vpin_backbox_width() - 2*t();
function vpin_backbox_x0() = (cab_w()-active_vpin_backbox_width())/2;
function vpin_backbox_front_y() = cab_d() - active_vpin_backbox_depth() + vpin_backbox_rear_overhang;
function vpin_backbox_bottom_z() = vpin_body_z() + vpin_rear_h() + vpin_backbox_bottom_gap;
function vpin_backbox_display_y0() = active_vpin_backbox_height() - active_vpin_backbox_display_h() - 28;
function vpin_backbox_lower_center_y() = max(55, vpin_backbox_display_y0()/2);

function sw() = active_screen_rotate_90() ? active_screen_height() : active_screen_width();
function sh() = active_screen_rotate_90() ? active_screen_width() : active_screen_height();
function is_arcade() = active_cabinet_style() == "standup" || active_cabinet_style() == "bartop";
function is_vpin() = active_cabinet_style() == "vpin" || active_cabinet_style() == "vpin_bartop";
function is_full_vpin() = active_cabinet_style() == "vpin";
function t() = active_material_thickness();
function clamp(v,lo,hi) = min(max(v,lo),hi);

function resolved_arcade_profile() =
    preset_active() && !preset_is("vpin_731x1308")
      ? design_preset
      : (arcade_profile == "auto"
          ? (active_cabinet_style() == "bartop" ? "curved" : "classic")
          : arcade_profile);

function marquee_on() =
    is_arcade() &&
    (marquee_mode == "on" ||
     (marquee_mode == "auto" && resolved_arcade_profile() != "viewlix"));

function auto_cab_width() =
    is_vpin()
      ? max(active_players() == 2 ? 700 : 600, sw() + 2*vpin_side_screen_margin + 2*t())
      : max(active_players() == 2 ? 700 : 560, sw() + 2*active_screen_side_margin() + 2*t());

function cab_w() = preset_active() && preset_use_plan_geometry ? preset_cab_width() : (cabinet_width > 0 ? cabinet_width : auto_cab_width());
function inner_w() = cab_w() - 2*t();
function cp_depth() = preset_active() && preset_use_plan_geometry ? preset_control_depth() : (is_vpin() ? vpin_control_panel_depth : arcade_control_panel_depth);

function cab_d() = preset_active() && preset_use_plan_geometry ? preset_body_depth() :
                   (active_cabinet_style() == "standup" ? standup_depth :
                    active_cabinet_style() == "bartop" ? bartop_depth :
                    max(sh() + active_vpin_depth_extra(), 900));

function cp_z() = preset_active() && preset_use_plan_geometry ? preset_control_height() : (active_cabinet_style() == "standup" ? standup_control_height : bartop_control_height);
function cp_overhang() = preset_active() && preset_use_plan_geometry ? preset_control_overhang() : (active_cabinet_style() == "standup" ? standup_control_overhang : bartop_control_overhang);
function cp_front_y() = -cp_overhang();
function cp_rear_y() = cp_front_y() + cp_depth()*cos(active_control_panel_angle());
function cp_rear_z() = cp_z() + cp_depth()*sin(active_control_panel_angle());

function arcade_screen_panel_len() = sh() + 2*active_screen_tb_margin();
function screen_open_w() = sw() + 2*screen_cutout_clearance;
function screen_open_h() = sh() + 2*screen_cutout_clearance;
function inside_corner_r() = max(screen_corner_radius, tool_diameter/2);

// VESA mount helpers. The carrier is parallel to the screen plane.
function active_screen_panel_len() = is_vpin() ? vpin_playfield_len() : arcade_screen_panel_len();
function vesa_adjustable() = vesa_mount_style == "adjustable";
function vesa_fixed() = vesa_mount_style == "fixed";
function vesa_mount_panel_h_auto() = max(vesa_pattern_y + 2*vesa_panel_edge_margin, 160);
function vesa_mount_panel_h() = vesa_panel_height > 0 ? vesa_panel_height : vesa_mount_panel_h_auto();
function vesa_mount_panel_w() = vesa_adjustable() ? inner_w() - 2*t() : inner_w();
function vesa_mount_local_y0() = (active_screen_panel_len() - vesa_mount_panel_h())/2;
// Local Z of the carrier's back face. plate_xy() extrudes toward +local-Z,
// so its front face ends exactly vesa_panel_setback behind the bezel rear face.
function vesa_mount_local_z0() = -(vesa_panel_setback + t());
function vesa_mount_local_z0_at(setback) = -(setback + t());

// Adjustable-sled geometry. The two rails move with the carrier. Fixed side
// bolts are located at the REAR-most (maximum setback) carrier position, so
// the rails extend primarily behind the carrier instead of toward the bezel.
function vesa_adjust_travel() = vesa_adjust_max_setback - vesa_adjust_min_setback;
function vesa_adjust_slot_length() = vesa_adjust_travel() + vesa_adjust_slot_width;
function vesa_adjust_rail_depth() = vesa_adjust_slot_length() + 2*vesa_adjust_rail_end_margin;
function vesa_adjust_rail_h() = min(vesa_mount_panel_h(), vesa_adjust_rail_height);
function vesa_adjust_rail_y0() = vesa_mount_local_y0() + (vesa_mount_panel_h()-vesa_adjust_rail_h())/2;
function vesa_adjust_carrier_center_z() = -(vesa_panel_setback + t()/2);
function vesa_adjust_carrier_x_in_rail() = vesa_adjust_rail_end_margin + vesa_adjust_slot_width/2 + vesa_adjust_travel();
function vesa_adjust_rail_local_z0() = vesa_adjust_carrier_center_z() - vesa_adjust_carrier_x_in_rail();
function vesa_adjust_fixed_bolt_local_z() = -(vesa_adjust_max_setback + t()/2);
function vesa_adjust_bolt_y_local(i) = vesa_adjust_rail_h()/2 + (i == 0 ? -vesa_adjust_bolt_spacing_y/2 : vesa_adjust_bolt_spacing_y/2);
function vesa_adjust_tab_y_local(i) = vesa_adjust_rail_h()/2 + (i == 0 ? -vesa_adjust_carrier_tab_spacing_y/2 : vesa_adjust_carrier_tab_spacing_y/2);
function vesa_adjust_tab_y_in_carrier(i) = (vesa_adjust_rail_y0()-vesa_mount_local_y0()) + vesa_adjust_tab_y_local(i);

// World-space screen panel angle: 90° is vertical; smaller angles recline the top rearward.
function arcade_screen_panel_angle() = 90 - active_screen_recline_angle();
// The bezel plate extrudes along its local +Z. After rotation this thickness
// projects toward the player by t()*sin(panel_angle). Add that projection to
// the origin so control_to_screen_clearance is the true physical gap.
function arcade_screen_panel_forward_projection() = t()*sin(arcade_screen_panel_angle());
function arcade_screen_lower_y_auto() = cp_rear_y() + active_control_screen_clearance() + arcade_screen_panel_forward_projection();
function arcade_screen_lower_z_auto() = cp_rear_z() + active_screen_gap_above_control();
function arcade_screen_lower_y() = screen_lower_y_override != 0 ? screen_lower_y_override : arcade_screen_lower_y_auto();
function arcade_screen_lower_z() = screen_lower_z_override != 0 ? screen_lower_z_override : arcade_screen_lower_z_auto();
function arcade_screen_upper_y() = arcade_screen_lower_y() + arcade_screen_panel_len()*cos(arcade_screen_panel_angle());
function arcade_screen_upper_z() = arcade_screen_lower_z() + arcade_screen_panel_len()*sin(arcade_screen_panel_angle());

function marquee_panel_h() = preset_active() && preset_use_plan_geometry ? preset_marquee_h() :
                             (active_cabinet_style() == "standup" ? standup_marquee_height :
                              active_cabinet_style() == "bartop" ? bartop_marquee_height : 0);

function stand_h_auto() =
    max(1750,
        arcade_screen_upper_z() +
        (marquee_on() ? marquee_min_gap_above_screen + marquee_panel_h() + head_panel_gap : 90));

function bartop_h_auto() =
    resolved_arcade_profile() == "viewlix"
      ? max(700, arcade_screen_upper_z() + 65)
      : max(760,
            arcade_screen_upper_z() +
            (marquee_on() ? marquee_min_gap_above_screen + marquee_panel_h() + head_panel_gap : 65));

function cab_h() = preset_active() && preset_use_plan_geometry && is_arcade() ? preset_body_height() :
                   (active_cabinet_style() == "standup" ? (standup_height > 0 ? standup_height : stand_h_auto()) :
                    active_cabinet_style() == "bartop" ? (bartop_height > 0 ? bartop_height : bartop_h_auto()) :
                    (active_cabinet_style() == "vpin" ? active_vpin_rear_body_h() : active_vpin_bartop_rear_h()));

// The marquee is an outside face panel: it covers the exposed front edges of
// both horizontal head panels. Its top is therefore the cabinet top and its
// bottom is the lower face of the speaker shelf. The top cap sits behind the
// upper material-thickness band and the speaker shelf sits behind the lower
// material-thickness band.
function arcade_marquee_top_z() = cab_h();
function arcade_marquee_bottom_z() = arcade_marquee_top_z() - marquee_panel_h();
function arcade_marquee_front_y() = max(20, arcade_screen_upper_y() - (preset_active() && preset_use_plan_geometry ? preset_marquee_projection() : marquee_forward_projection));
function arcade_marquee_rear_y() = min(cab_d()-20, arcade_marquee_front_y() + (preset_active() && preset_use_plan_geometry ? preset_marquee_depth() : marquee_depth));
function arcade_head_inner_front_y() = arcade_marquee_front_y() + t() + head_panel_gap;
function arcade_head_depth() = max(40, arcade_marquee_rear_y() - arcade_head_inner_front_y());
function arcade_speaker_panel_depth() = speaker_panel_depth <= 0 ? arcade_head_depth() : min(speaker_panel_depth, arcade_head_depth());
function arcade_speaker_panel_y() = arcade_head_inner_front_y();
function arcade_speaker_panel_z() = arcade_marquee_bottom_z() + head_panel_gap;
function speaker_on() = is_arcade() && marquee_on() && active_speaker_shelf_enabled() && arcade_speaker_panel_depth() > 0;

function vpin_front_h() = active_cabinet_style() == "vpin" ? active_vpin_front_body_h() : active_vpin_bartop_front_h();
function vpin_rear_h() = active_cabinet_style() == "vpin" ? active_vpin_rear_body_h() : active_vpin_bartop_rear_h();
function vpin_body_z() = active_cabinet_style() == "vpin" ? active_vpin_leg_height() : 0;
function vpin_top_rise() = vpin_rear_h() - vpin_front_h();
function vpin_top_angle() = atan2(vpin_top_rise(), cab_d());
function vpin_top_length() = sqrt(cab_d()*cab_d() + vpin_top_rise()*vpin_top_rise());
function vpin_playfield_len() = max(sh() + 2*active_screen_tb_margin(), vpin_top_length() - active_vpin_front_apron() - active_vpin_rear_apron());

// Side-view frame for the active screen/playfield panel. Coordinates here are
// local to the cabinet body (vpin_body_z() is added only in the 3D assembly).
function active_screen_angle() = is_vpin() ? vpin_top_angle() : arcade_screen_panel_angle();
function active_screen_origin_y() = is_vpin() ? active_vpin_front_apron()*cos(vpin_top_angle()) : arcade_screen_lower_y();
function active_screen_origin_z_local() = is_vpin()
    ? vpin_front_h() + active_vpin_front_apron()*sin(vpin_top_angle())
    : arcade_screen_lower_z();
function vesa_mount_origin_y() = active_screen_origin_y()
    + vesa_mount_local_y0()*cos(active_screen_angle())
    - vesa_mount_local_z0()*sin(active_screen_angle());
function vesa_mount_origin_z_local() = active_screen_origin_z_local()
    + vesa_mount_local_y0()*sin(active_screen_angle())
    + vesa_mount_local_z0()*cos(active_screen_angle());

function screen_local_to_side_y(u,z) = active_screen_origin_y()
    + u*cos(active_screen_angle()) - z*sin(active_screen_angle());
function screen_local_to_side_z(u,z) = active_screen_origin_z_local()
    + u*sin(active_screen_angle()) + z*cos(active_screen_angle());

function front_panel_h() = is_vpin() ? vpin_front_h() : max(90, cp_z() - 35);
function rear_panel_h() = is_vpin() ? vpin_rear_h() : cab_h() - 55;
function top_panel_depth() = is_vpin() ? 0 : (marquee_on() ? arcade_head_depth() : 160);

// ---------- Assertions ----------
assert(active_players() == 1 || active_players() == 2, "players must be 1 or 2");
assert(active_buttons_per_player() >= 4 && active_buttons_per_player() <= 8, "buttons_per_player must be 4..8");
assert(inner_w() > screen_open_w() + 10, "Cabinet is too narrow for the requested screen opening.");
assert(t() > 0 && plexi_thickness > 0, "Material thicknesses must be positive.");
assert(active_control_screen_clearance() >= 0, "control_to_screen_clearance must be >= 0.");
assert(panel_joinery == "none" || panel_joinery == "screw" || panel_joinery == "tab_slot", "panel_joinery must be none, screw, or tab_slot.");
assert(joinery_count >= 1 && joinery_count <= 4, "joinery_count must be 1..4.");
assert(joinery_screw_hole_diameter > 0, "joinery_screw_hole_diameter must be positive.");
assert(panel_joinery != "tab_slot" || (joinery_tab_depth > 0 && joinery_tab_depth <= t()), "joinery_tab_depth must be > 0 and <= material_thickness.");
assert(joinery_slot_clearance >= 0, "joinery_slot_clearance must be non-negative.");
assert(active_screen_recline_angle() >= 0 && active_screen_recline_angle() < 35, "screen_recline_angle should be 0..34 degrees from vertical.");
assert(vesa_mount_style == "fixed" || vesa_mount_style == "adjustable", "vesa_mount_style must be fixed or adjustable.");
assert(vesa_panel_setback >= 0, "vesa_panel_setback must be non-negative.");
assert(vesa_pattern_x > 0 && vesa_pattern_y > 0, "VESA pattern spacing must be positive.");
assert(vesa_hole_diameter > 0, "vesa_hole_diameter must be positive.");
assert(!vesa_mount_panel_enabled || vesa_mount_panel_h() >= vesa_pattern_y + 2*vesa_panel_edge_margin, "VESA panel is too short for the requested Y pattern plus edge margins.");
assert(!vesa_mount_panel_enabled || abs(vesa_center_x_offset) + vesa_pattern_x/2 + vesa_panel_edge_margin <= vesa_mount_panel_w()/2, "VESA X pattern/offset does not fit the carrier width with the requested margin.");
assert(!vesa_mount_panel_enabled || abs(vesa_center_y_offset) + vesa_pattern_y/2 + vesa_panel_edge_margin <= vesa_mount_panel_h()/2, "VESA Y pattern/offset does not fit the mount panel with the requested margin.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || inner_w() > 4*t(), "Cabinet is too narrow for the adjustable VESA rails plus carrier.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || (vesa_adjust_min_setback >= 0 && vesa_adjust_max_setback > vesa_adjust_min_setback), "Adjustable VESA min/max setback range is invalid.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || (vesa_panel_setback >= vesa_adjust_min_setback && vesa_panel_setback <= vesa_adjust_max_setback), "vesa_panel_setback must lie inside the adjustable min/max range.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_bolt_hole_diameter > 0, "VESA adjustment bolt diameter must be positive.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_slot_width >= vesa_adjust_bolt_hole_diameter, "VESA rail slot width must be at least the side-bolt hole diameter.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_rail_end_margin > 0, "VESA rail end margin must be positive.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_min_setback + t()/2 > vesa_adjust_rail_end_margin + vesa_adjust_slot_width/2, "Adjustable VESA rail would project through the bezel plane at minimum setback; increase vesa_adjust_min_setback or reduce rail end margin.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_rail_h() >= vesa_adjust_bolt_spacing_y + vesa_adjust_slot_width + 12, "VESA rail is too short for the two adjustment slots and requested spacing.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_carrier_tab_width > 0, "VESA carrier tab width must be positive.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_carrier_tab_spacing_y >= vesa_adjust_carrier_tab_width + 4, "VESA carrier tabs overlap; increase tab spacing or reduce tab width.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_carrier_tab_spacing_y + vesa_adjust_carrier_tab_width <= vesa_adjust_bolt_spacing_y - vesa_adjust_slot_width - 4, "VESA carrier tab mortises overlap the adjustment slots; increase rail height/bolt spacing or tighten tab spacing.");
assert(!is_arcade() || arcade_screen_upper_y() < cab_d()-20, "Screen recline/depth combination pushes the monitor beyond the rear of the cabinet. Increase cabinet depth or reduce screen_recline_angle.");
assert(!is_arcade() || arcade_screen_upper_z() < cab_h()-20, "Cabinet is too short for the requested screen and monitor angle.");
assert(!is_arcade() || !active_coin_door_enabled() || active_coin_door_width()+10 <= inner_w(), "Coin door is too wide for the front panel.");
assert(!is_arcade() || !active_coin_door_enabled() || active_coin_door_bottom_z()+active_coin_door_height()+5 <= front_panel_h(), "Coin door is too tall/high for the front panel.");
assert(!is_arcade() || !active_keyboard_drawer_enabled() || active_keyboard_drawer_width()+10 <= inner_w(), "Keyboard drawer is too wide for the front panel.");
assert(!is_arcade() || !active_keyboard_drawer_enabled() || active_keyboard_drawer_bottom_z()+active_keyboard_drawer_height()+5 <= front_panel_h(), "Keyboard drawer opening is too tall/high for the front panel.");
assert(!is_arcade() || !active_rear_service_door_enabled() || active_rear_service_door_width()+10 <= inner_w(), "Rear service door is too wide for the rear panel.");
assert(!is_arcade() || !active_rear_service_door_enabled() || active_rear_service_door_bottom_z()+active_rear_service_door_height()+5 <= rear_panel_h(), "Rear service door is too tall/high for the rear panel.");
assert(!is_vpin() || !active_vpin_backbox_enabled() || active_vpin_backbox_width() <= cab_w()+0.01, "Backbox width cannot exceed cabinet width in the current centered mount.");
assert(!is_vpin() || !active_vpin_backbox_enabled() || active_vpin_backbox_display_w()+20 <= vpin_backbox_inner_w(), "Backbox display opening is too wide.");
assert(!is_vpin() || !active_vpin_backbox_enabled() || active_vpin_backbox_display_h()+60 <= active_vpin_backbox_height(), "Backbox is too short for the requested display opening and lower speaker/DMD zone.");

// ---------- 2D primitives ----------
module rounded_rect_2d(w, h, r=0, center=false) {
    rr = min(max(r,0), min(w,h)/2);
    if (rr <= 0) {
        square([w,h], center=center);
    } else if (center) {
        hull() {
            for (x=[-w/2+rr, w/2-rr])
                for (y=[-h/2+rr, h/2-rr])
                    translate([x,y]) circle(r=rr, $fn=48);
        }
    } else {
        hull() {
            for (x=[rr, w-rr])
                for (y=[rr, h-rr])
                    translate([x,y]) circle(r=rr, $fn=48);
        }
    }
}

function joinery_active() = panel_joinery != "none";
function tab_joinery() = panel_joinery == "tab_slot";
function screw_joinery() = panel_joinery == "screw";
function joint_u(i,len) = (i+1)*len/(joinery_count+1);
function joint_feature_len(len) = min(joinery_tab_width, max(8, len/(joinery_count+1)*0.75));

module panel_outline_with_tabs(w,d,eligible=true) {
    if (eligible && tab_joinery()) {
        union() {
            square([w,d]);
            fw = joint_feature_len(d);
            for (i=[0:joinery_count-1]) {
                u = joint_u(i,d);
                translate([-joinery_tab_depth,u-fw/2]) square([joinery_tab_depth,fw]);
                translate([w,u-fw/2]) square([joinery_tab_depth,fw]);
            }
        }
    } else {
        square([w,d]);
    }
}

module dogbone_slot_2d(len,wid) {
    union() {
        square([len,wid],center=true);
        if (joinery_dogbone_relief) {
            r = tool_diameter/2;
            for (sx=[-1,1])
                for (sy=[-1,1])
                    translate([sx*len/2,sy*wid/2]) circle(r=r,$fn=32);
        }
    }
}

module capsule_slot_2d(len,wid) {
    // Overall length includes the rounded ends.
    ll = max(len,wid);
    hull() {
        translate([-(ll-wid)/2,0]) circle(d=wid,$fn=40);
        translate([(ll-wid)/2,0]) circle(d=wid,$fn=40);
    }
}

module vesa_mortise_2d(len,wid) {
    union() {
        square([len,wid],center=true);
        if (vesa_adjust_joinery_dogbones) {
            r = tool_diameter/2;
            for (sx=[-1,1])
                for (sy=[-1,1])
                    translate([sx*len/2,sy*wid/2]) circle(r=r,$fn=28);
        }
    }
}

// Cut a series of side-panel features matching one cross panel. y0/z0 are the
// local side-view origin of that panel, len is its local Y dimension, and angle
// matches the panel's world X-axis rotation used in the 3D assembly.
module side_joint_features(y0,z0,len,angle_deg,eligible=true) {
    if (eligible && joinery_active() && len > 0) {
        fw = joint_feature_len(len);
        for (i=[0:joinery_count-1]) {
            u = joint_u(i,len);
            translate([y0,z0])
                rotate(angle_deg)
                    translate([u,t()/2])
                        if (screw_joinery())
                            circle(d=joinery_screw_hole_diameter,$fn=36);
                        else if (tab_joinery())
                            dogbone_slot_2d(fw+joinery_slot_clearance,t()+joinery_slot_clearance);
        }
    }
}

function effective_player_spacing(w) = min(player_spacing, w*0.48);
function player_center_x(i,w) = active_players() == 1 ? w/2 : w/2 + (i == 0 ? -effective_player_spacing(w)/2 : effective_player_spacing(w)/2);
function aux_on_control() = active_aux_button_location() == "control" || active_aux_button_location() == "both";
function aux_on_front() = active_aux_button_location() == "front" || active_aux_button_location() == "both";

module action_button_holes(w, d, extra=0) {
    top_n = ceil(active_buttons_per_player()/2);
    bottom_n = floor(active_buttons_per_player()/2);
    controls_y = d*0.60;

    for (p=[0:active_players()-1]) {
        pc = player_center_x(p,w);
        cluster_cx = pc + joystick_to_button_cluster/2;
        x0 = cluster_cx - (top_n-1)*button_spacing_x/2;

        for (i=[0:top_n-1])
            translate([x0 + i*button_spacing_x, controls_y + button_spacing_y/2])
                circle(d=action_button_diameter + 2*extra, $fn=48);

        for (i=[0:bottom_n-1])
            translate([x0 + button_spacing_x/2 + i*button_spacing_x, controls_y - button_spacing_y/2])
                circle(d=action_button_diameter + 2*extra, $fn=48);
    }
}

module joystick_holes(w, d, extra=0, include_mounts=true) {
    if (active_include_joysticks()) {
        controls_y = d*0.60;
        for (p=[0:active_players()-1]) {
            pc = player_center_x(p,w);
            jx = pc - joystick_to_button_cluster/2;
            jy = controls_y;
            translate([jx,jy]) circle(d=joystick_shaft_hole + 2*extra, $fn=48);
            if (include_mounts && joystick_mount_holes_enabled) {
                for (dx=[-joystick_mount_spacing_x/2, joystick_mount_spacing_x/2])
                    for (dy=[-joystick_mount_spacing_y/2, joystick_mount_spacing_y/2])
                        translate([jx+dx,jy+dy]) circle(d=joystick_mount_hole_diameter + 2*extra, $fn=32);
            }
        }
    }
}

module trackball_holes(w, d, extra=0, include_mounts=true) {
    if (active_trackball_enabled()) {
        tx = w/2 + trackball_x_offset;
        ty = d*trackball_y_fraction;
        translate([tx,ty]) circle(d=trackball_cutout_diameter + 2*extra, $fn=64);
        if (include_mounts && trackball_mount_holes_enabled) {
            for (dx=[-trackball_mount_spacing_x/2, trackball_mount_spacing_x/2])
                for (dy=[-trackball_mount_spacing_y/2, trackball_mount_spacing_y/2])
                    translate([tx+dx,ty+dy]) circle(d=trackball_mount_hole_diameter + 2*extra, $fn=32);
        }
    }
}

module aux_control_holes(w, d, extra=0) {
    if (active_aux_button_count() > 0 && aux_on_control()) {
        y = d - aux_rear_margin;
        x0 = w/2 - (active_aux_button_count()-1)*aux_button_spacing/2;
        for (i=[0:active_aux_button_count()-1])
            translate([x0+i*aux_button_spacing,y]) circle(d=aux_button_diameter + 2*extra, $fn=48);
    }
}

module aux_front_holes(w, h, extra=0) {
    if (active_aux_button_count() > 0 && aux_on_front()) {
        y = h*aux_front_height_fraction;
        x0 = w/2 - (active_aux_button_count()-1)*aux_button_spacing/2;
        for (i=[0:active_aux_button_count()-1])
            translate([x0+i*aux_button_spacing,y]) circle(d=aux_button_diameter + 2*extra, $fn=48);
    }
}

module control_cutouts(w, d, extra=0, include_mounts=true) {
    action_button_holes(w,d,extra);
    joystick_holes(w,d,extra,include_mounts);
    trackball_holes(w,d,extra,include_mounts);
    aux_control_holes(w,d,extra);
}

module control_panel_2d(plexi=false) {
    w = inner_w();
    d = cp_depth();
    extra = plexi ? plexi_hole_clearance : 0;
    inset = plexi ? plexi_edge_inset : 0;
    difference() {
        if (plexi)
            translate([inset,inset]) square([w-2*inset,d-2*inset]);
        else
            panel_outline_with_tabs(w,d,true);
        control_cutouts(w,d,extra,true);
    }
}

module screen_panel_2d(plexi=false) {
    w = inner_w();
    h = is_vpin() ? vpin_playfield_len() : arcade_screen_panel_len();
    inset = plexi ? plexi_edge_inset : 0;
    difference() {
        if (plexi)
            translate([inset,inset]) square([w-2*inset,h-2*inset]);
        else
            panel_outline_with_tabs(w,h,is_vpin());
        if (!plexi || monitor_plexi_window)
            translate([w/2,h/2]) rounded_rect_2d(screen_open_w(),screen_open_h(),inside_corner_r(),true);
    }
}

module vesa_adjustable_carrier_outline_2d(w,h) {
    union() {
        square([w,h]);
        for (i=[0:1]) {
            ty = vesa_adjust_tab_y_in_carrier(i);
            translate([-t(),ty-vesa_adjust_carrier_tab_width/2])
                square([t(),vesa_adjust_carrier_tab_width]);
            translate([w,ty-vesa_adjust_carrier_tab_width/2])
                square([t(),vesa_adjust_carrier_tab_width]);
        }
    }
}

module vesa_mount_panel_2d() {
    if (vesa_mount_panel_enabled) {
        w = vesa_mount_panel_w();
        h = vesa_mount_panel_h();
        cx = w/2 + vesa_center_x_offset;
        cy = h/2 + vesa_center_y_offset;
        difference() {
            if (vesa_adjustable())
                vesa_adjustable_carrier_outline_2d(w,h);
            else
                panel_outline_with_tabs(w,h,vesa_panel_use_joinery);            for (sx=[-1,1])
                for (sy=[-1,1])
                    translate([cx + sx*vesa_pattern_x/2,
                               cy + sy*vesa_pattern_y/2])
                        circle(d=vesa_hole_diameter,$fn=40);
        }
    }
}

module vesa_adjust_rail_2d() {
    if (vesa_mount_panel_enabled && vesa_adjustable()) {
        d = vesa_adjust_rail_depth();
        h = vesa_adjust_rail_h();
        difference() {
            square([d,h]);

            // Long slots slide around fixed bolts in the cabinet side panels.
            for (i=[0:1])
                translate([d/2,vesa_adjust_bolt_y_local(i)])
                    capsule_slot_2d(vesa_adjust_slot_length(),vesa_adjust_slot_width);

            // Mortises receive the carrier's two tabs near the rail's front end.
            for (i=[0:1])
                translate([vesa_adjust_carrier_x_in_rail(),vesa_adjust_tab_y_local(i)])
                    vesa_mortise_2d(t()+vesa_adjust_joinery_clearance,
                                    vesa_adjust_carrier_tab_width+vesa_adjust_joinery_clearance);
        }
    }
}

module control_fascia_panel_2d() {
    if (is_arcade() && preset_control_fascia_enabled()) {
        w=inner_w(); h=active_control_fascia_height();
        difference() {
            panel_outline_with_tabs(w,h,true);
            if (aux_on_front()) aux_front_holes(w,h,0);
        }
    }
}

module admin_panel_2d() {
    if (is_arcade() && active_admin_panel_enabled()) {
        w=inner_w(); h=active_admin_panel_height();
        difference() {
            panel_outline_with_tabs(w,h,true);
            if (admin_button_count > 0) {
                x0=w/2-(admin_button_count-1)*admin_button_spacing/2;
                for(i=[0:admin_button_count-1])
                    translate([x0+i*admin_button_spacing,h/2]) circle(d=admin_button_diameter,$fn=40);
            }
        }
    }
}

module keyboard_drawer_front_2d() {
    if (is_arcade() && active_keyboard_drawer_enabled())
        square([active_keyboard_drawer_width(),active_keyboard_drawer_height()]);
}

module keyboard_drawer_shelf_2d() {
    if (is_arcade() && active_keyboard_drawer_enabled())
        square([active_keyboard_drawer_width(),active_keyboard_drawer_depth()]);
}

module coin_door_2d() {
    if (is_arcade() && active_coin_door_enabled()) {
        w=active_coin_door_width(); h=active_coin_door_height();
        difference() {
            square([w,h]);
            if (coin_door_button_count > 0) {
                sp=min(60,w/(coin_door_button_count+1));
                x0=w/2-(coin_door_button_count-1)*sp/2;
                for(i=[0:coin_door_button_count-1])
                    translate([x0+i*sp,h*0.72]) circle(d=coin_door_button_diameter,$fn=40);
            }
        }
    }
}

module rear_service_door_2d() {
    if (is_arcade() && active_rear_service_door_enabled()) {
        w=active_rear_service_door_width(); h=active_rear_service_door_height();
        difference() {
            square([w,h]);
            inset=32;
            for(x=[inset,w-inset])
                for(y=[inset,h-inset])
                    translate([x,y]) circle(d=rear_service_door_mount_hole_diameter,$fn=32);
            if (rear_service_door_vent_holes > 0) {
                n=rear_service_door_vent_holes;
                rows=ceil(n/2);
                for(i=[0:n-1]) {
                    row=floor(i/2); col=i%2;
                    translate([w*(0.35+0.30*col),h*(row+1)/(rows+1)])
                        circle(d=rear_service_door_vent_diameter,$fn=48);
                }
            }
        }
    }
}

module front_panel_2d() {
    w = inner_w();
    h = front_panel_h();
    difference() {
        square([w,h]);
        if (coin_button_enabled)
            translate([w/2, h*0.48]) circle(d=coin_button_diameter,$fn=48);
        if (is_arcade() && aux_on_front() && !preset_control_fascia_enabled())
            aux_front_holes(w,h,0);
        if (is_arcade() && active_coin_door_enabled())
            translate([(w-active_coin_door_width())/2,active_coin_door_bottom_z()])
                square([active_coin_door_width()+coin_door_clearance,
                        active_coin_door_height()+coin_door_clearance]);
        if (is_arcade() && active_keyboard_drawer_enabled())
            translate([(w-active_keyboard_drawer_width())/2,active_keyboard_drawer_bottom_z()])
                square([active_keyboard_drawer_width()+keyboard_drawer_clearance,
                        active_keyboard_drawer_height()+keyboard_drawer_clearance]);
        if (is_vpin() && pinball_plunger_enabled)
            translate([w*0.82,h*0.68]) circle(d=pinball_plunger_hole_diameter,$fn=48);
    }
}

module rear_panel_2d() {
    w=inner_w(); h=rear_panel_h();
    difference() {
        square([w,h]);
        if (is_arcade() && active_rear_service_door_enabled())
            translate([(w-active_rear_service_door_width())/2,active_rear_service_door_bottom_z()])
                square([active_rear_service_door_width()+rear_service_door_clearance,
                        active_rear_service_door_height()+rear_service_door_clearance]);
    }
}

module bottom_panel_2d() {
    panel_outline_with_tabs(inner_w(),cab_d(),true);
}

module top_panel_2d() {
    if (is_arcade()) panel_outline_with_tabs(inner_w(),top_panel_depth(),true);
}

module marquee_panel_2d() {
    if (marquee_on()) square([inner_w(),marquee_panel_h()]);
}

module speaker_panel_2d() {
    if (speaker_on()) {
        w = inner_w();
        d = arcade_speaker_panel_depth();
        difference() {
            panel_outline_with_tabs(w,d,true);
            if (speaker_count > 0) {
                sp = min(speaker_spacing, speaker_count <= 1 ? 0 : (w-speaker_cutout_diameter-30)/(speaker_count-1));
                x0 = speaker_count == 1 ? w/2 : w/2 - (speaker_count-1)*sp/2;
                for (i=[0:speaker_count-1])
                    translate([x0+i*sp,d/2]) circle(d=speaker_cutout_diameter,$fn=64);
            }
        }
    }
}

module speaker_baffle_panel_2d() {
    if (is_arcade() && marquee_on() && active_speaker_baffle_enabled()) {
        w=inner_w(); h=active_speaker_baffle_height();
        difference() {
            panel_outline_with_tabs(w,h,true);
            if (speaker_count > 0) {
                sp=min(speaker_spacing,speaker_count<=1?0:(w-speaker_cutout_diameter-30)/(speaker_count-1));
                x0=speaker_count==1?w/2:w/2-(speaker_count-1)*sp/2;
                for(i=[0:speaker_count-1])
                    translate([x0+i*sp,h/2]) circle(d=speaker_cutout_diameter,$fn=64);
            }
        }
    }
}

module vpin_backbox_side_2d() {
    if (active_vpin_backbox_enabled())
        square([active_vpin_backbox_depth(),active_vpin_backbox_height()]);
}

module vpin_backbox_front_2d(plexi=false) {
    if (active_vpin_backbox_enabled()) {
        w=vpin_backbox_inner_w(); h=active_vpin_backbox_height();
        inset=plexi?plexi_edge_inset:0;
        difference() {
            if (plexi) translate([inset,inset]) square([w-2*inset,h-2*inset]);
            else square([w,h]);
            if (!plexi || vpin_backbox_plexi_window) {
                translate([w/2,vpin_backbox_display_y0()+active_vpin_backbox_display_h()/2])
                    rounded_rect_2d(active_vpin_backbox_display_w(),active_vpin_backbox_display_h(),
                                    max(vpin_backbox_display_corner_radius,tool_diameter/2),true);
                if (vpin_backbox_dmd_enabled)
                    translate([w/2,vpin_backbox_lower_center_y()])
                        rounded_rect_2d(vpin_backbox_dmd_width,vpin_backbox_dmd_height,tool_diameter/2,true);
                if (vpin_backbox_speaker_count > 0) {
                    sp=min(vpin_backbox_speaker_spacing,
                           vpin_backbox_speaker_count<=1?0:(w-vpin_backbox_speaker_diameter-30)/(vpin_backbox_speaker_count-1));
                    x0=vpin_backbox_speaker_count==1?w/2:w/2-(vpin_backbox_speaker_count-1)*sp/2;
                    for(i=[0:vpin_backbox_speaker_count-1])
                        translate([x0+i*sp,vpin_backbox_lower_center_y()])
                            circle(d=vpin_backbox_speaker_diameter,$fn=64);
                }
            }
        }
    }
}

module vpin_backbox_rear_2d() {
    if (active_vpin_backbox_enabled()) square([vpin_backbox_inner_w(),active_vpin_backbox_height()]);
}
module vpin_backbox_top_2d() {
    if (active_vpin_backbox_enabled()) square([vpin_backbox_inner_w(),active_vpin_backbox_depth()]);
}
module vpin_backbox_bottom_2d() { vpin_backbox_top_2d(); }
module vpin_backbox_plexi_2d() { vpin_backbox_front_2d(true); }

module control_plexi_2d() { control_panel_2d(true); }
module screen_plexi_2d() { screen_panel_2d(true); }
module marquee_plexi_2d() {
    if (marquee_on()) {
        inset = plexi_edge_inset;
        translate([inset,inset]) square([inner_w()-2*inset,marquee_panel_h()-2*inset]);
    }
}

// ---------- Side profiles ----------
function bezier3_point(p0,p1,p2,p3,tv) = [
    pow(1-tv,3)*p0[0] + 3*pow(1-tv,2)*tv*p1[0] + 3*(1-tv)*pow(tv,2)*p2[0] + pow(tv,3)*p3[0],
    pow(1-tv,3)*p0[1] + 3*pow(1-tv,2)*tv*p1[1] + 3*(1-tv)*pow(tv,2)*p2[1] + pow(tv,3)*p3[1]
];
function bezier3_points(p0,p1,p2,p3,n=8) = [for(i=[1:n]) bezier3_point(p0,p1,p2,p3,i/n)];

// TinyArcade drawing: 420 x 500 mm side, 15 mm stock, 470 mm inner-width
// panels. The large R214.82 curve is represented by a smooth sampled cubic
// that follows the dimensioned head/control endpoints.
function tinyarcade_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(),
    head_front=D-194,
    head_bottom=H-62,
    curve_end=[max(25,arcade_screen_lower_y()-15), max(C+25,arcade_screen_lower_z()-5)]
) concat(
    [[0,0],[D,0],[D,H],[head_front,H],[head_front,head_bottom]],
    bezier3_points([head_front,head_bottom],[head_front-8,head_bottom-105],[curve_end[0]+65,curve_end[1]+30],curve_end,10),
    [[0,C+30],[0,C-5]]
);

// Koenigs/MAME-inspired upright. Several small offsets in the source image are
// difficult to read, so the main 600-ish depth / 1800 height proportions are
// retained while the monitor neck follows the active screen geometry.
function koenigs_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z(),
    mf=arcade_marquee_front_y(), mb=arcade_marquee_bottom_z()
) [
    [0,0],[D,0],[D,H],[max(mf+170,D-240),H],[mf,H],[mf,mb],
    [sy1-35,sz1+45],[sy0-22,sz0-35],[cp_rear_y()+5,cp_rear_z()+5],
    [-O,C+55],[-O,C-45],[0,C-95]
];

// 1600 mm compact upright from the supplied curved-side drawing.
function compact1600_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z(),
    mf=arcade_marquee_front_y(), mb=arcade_marquee_bottom_z(),
    p0=[mf,mb], p3=[cp_rear_y()+10,cp_rear_z()+15]
) concat(
    [[0,0],[D,0],[D,H],[max(mf+120,D-220),H],[mf,H],[mf,mb]],
    bezier3_points(p0,[mf-10,mb-180],[p3[0]+90,p3[1]+130],p3,10),
    [[-O,C+45],[-O,C-42],[0,C-90]]
);

// Asteroids/Niels drawing: 1892 high, 550 body depth + ~100 mm control
// projection, 700 mm clear width, and 510 x 290 visible screen.
function asteroids_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z(),
    mf=arcade_marquee_front_y(), mb=arcade_marquee_bottom_z(),
    p0=[mf,mb], p3=[cp_rear_y()+5,cp_rear_z()+20]
) concat(
    [[0,0],[D,0],[D,H],[max(mf+260,D-50),H],[mf,H],[mf,mb]],
    bezier3_points(p0,[mf-25,mb-90],[p3[0]+70,p3[1]+180],p3,9),
    [[-O,C+45],[-O,C-55],[0,C-95]]
);

// Traditional 1980s cabinet approximation based on the supplied silhouette.
function classic80s_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z(),
    mf=arcade_marquee_front_y(), mb=arcade_marquee_bottom_z()
) [
    [0,0],[D,0],[D,H],[D-150,H],[mf+30,H],[mf,mb],
    [sy1-55,sz1+45],[sy0-25,sz0-20],[cp_rear_y()+15,cp_rear_z()+10],
    [-O,C+45],[-O,C-45],[0,C-105]
];

// We Build Stuff side plan: 185 cm tall, 59.51 cm deep, ~96.02 cm control
// height and strongly angular 135/115 degree head/monitor transitions.
function we_build_stuff_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z(),
    mf=arcade_marquee_front_y(), mb=arcade_marquee_bottom_z()
) [
    [0,0],[D,0],[D,H],[max(D-500,0),H],[mf,H],[mf,mb],
    [sy1-20,sz1+25],[sy0-12,sz0-10],[cp_rear_y()+8,cp_rear_z()+8],
    [-O,C+32],[-O,C-52],[0,C-100]
];

function classic_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z(),
    mf=marquee_on() ? arcade_marquee_front_y() : max(70,sy1-50),
    mr=marquee_on() ? arcade_marquee_rear_y() : min(D-40,sy1+150),
    mb=marquee_on() ? arcade_marquee_bottom_z() : sz1+40
) [
    [0,0], [D,0], [D,H],
    [mr,H], [mf,H], [mf,mb],
    [sy1-32,sz1+30], [sy0-35,sz0-28],
    [cp_rear_y()+12,cp_rear_z()+12],
    [-O,C+55], [-O,C-45], [0,C-120]
];

function curved_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z(),
    mf=marquee_on() ? arcade_marquee_front_y() : max(65,sy1-45),
    mr=marquee_on() ? arcade_marquee_rear_y() : min(D-35,sy1+145),
    mb=marquee_on() ? arcade_marquee_bottom_z() : sz1+35
) [
    [0,0], [D,0], [D,H],
    [mr,H], [mf,H], [mf,mb],
    [sy1-38,sz1+28],
    [sy1-62,sz1-35], [sy0-58,sz0+28], [sy0-46,sz0-30],
    [cp_rear_y()+10,cp_rear_z()+8],
    [-O,C+50], [-O,C-42], [0,C-100]
];

function viewlix_profile() = let(
    D=cab_d(), H=cab_h(), C=cp_z(), O=cp_overhang(),
    sy0=arcade_screen_lower_y(), sz0=arcade_screen_lower_z(),
    sy1=arcade_screen_upper_y(), sz1=arcade_screen_upper_z()
) [
    [0,0], [D,0], [D,H],
    [min(D-25,sy1+125),H], [sy1-28,sz1+38],
    [sy0-35,sz0-30], [cp_rear_y()+10,cp_rear_z()+8],
    [-O,C+48], [-O,C-38], [0,C-100]
];

function plan_profile() =
    resolved_arcade_profile() == "tinyarcade_bartop" ? tinyarcade_profile() :
    resolved_arcade_profile() == "koenigs_mame" ? koenigs_profile() :
    resolved_arcade_profile() == "compact_1600" ? compact1600_profile() :
    resolved_arcade_profile() == "asteroids" ? asteroids_profile() :
    resolved_arcade_profile() == "classic_80s" ? classic80s_profile() :
    resolved_arcade_profile() == "we_build_stuff" ? we_build_stuff_profile() : [];

function standup_profile() =
    preset_active() && !preset_is("vpin_731x1308") ? plan_profile() :
    resolved_arcade_profile() == "viewlix" ? viewlix_profile() :
    resolved_arcade_profile() == "curved" ? curved_profile() :
    classic_profile();

function bartop_profile() =
    preset_active() && !preset_is("vpin_731x1308") ? plan_profile() :
    resolved_arcade_profile() == "viewlix" ? viewlix_profile() :
    resolved_arcade_profile() == "classic" ? classic_profile() :
    curved_profile();

function vpin_profile() = [
    [0,0], [cab_d(),0], [cab_d(),vpin_rear_h()], [0,vpin_front_h()]
];

function side_profile_points() = active_cabinet_style() == "standup" ? standup_profile() :
                                 active_cabinet_style() == "bartop" ? bartop_profile() :
                                 vpin_profile();

function vpin_top_at(y) = vpin_front_h() + (vpin_rear_h()-vpin_front_h())*(y/cab_d());

module arcade_side_outline_2d() {
    if (active_side_corner_radius() > 0)
        offset(r=active_side_corner_radius(), $fn=36)
            offset(delta=-active_side_corner_radius())
                polygon(points=side_profile_points());
    else
        polygon(points=side_profile_points());
}

module side_panel_joinery_cutouts() {
    if (joinery_active()) {
        if (is_arcade()) {
            // Bottom panel is intentionally raised one material thickness in the arcade body.
            side_joint_features(0,t(),cab_d(),0,true);
            side_joint_features(cp_front_y(),cp_z(),cp_depth(),active_control_panel_angle(),true);
            if (preset_control_fascia_enabled())
                side_joint_features(cp_front_y(),cp_z()-active_control_fascia_height(),active_control_fascia_height(),90,true);
            if (active_admin_panel_enabled()) {
                az_top=min(arcade_screen_lower_z()-4,cp_rear_z()+active_admin_panel_height());
                side_joint_features(cp_rear_y(),az_top-active_admin_panel_height(),active_admin_panel_height(),90,true);
            }
            if (vesa_mount_panel_enabled && vesa_fixed() && vesa_panel_use_joinery)
                side_joint_features(vesa_mount_origin_y(),vesa_mount_origin_z_local(),vesa_mount_panel_h(),active_screen_angle(),true);

            if (marquee_on()) {
                side_joint_features(arcade_head_inner_front_y(),cab_h()-t(),top_panel_depth(),0,true);
                if (speaker_on())
                    side_joint_features(arcade_speaker_panel_y(),arcade_speaker_panel_z(),arcade_speaker_panel_depth(),0,true);
                if (active_speaker_baffle_enabled())
                    side_joint_features(arcade_marquee_front_y(),arcade_marquee_bottom_z()-active_speaker_baffle_height(),active_speaker_baffle_height(),90,true);
            } else {
                top_y = max(30,arcade_screen_upper_y()-25);
                side_joint_features(top_y,cab_h()-t(),min(top_panel_depth(),cab_d()-top_y),0,true);
            }
        } else {
            // Vpin body coordinates are local to the body, before vpin_body_z() is added in 3D.
            side_joint_features(0,0,cab_d(),0,true);
            side_joint_features(-35,vpin_front_h(),cp_depth(),vpin_top_angle(),true);
            pf_y = active_vpin_front_apron()*cos(vpin_top_angle());
            pf_z = vpin_front_h() + active_vpin_front_apron()*sin(vpin_top_angle());
            side_joint_features(pf_y,pf_z,vpin_playfield_len(),vpin_top_angle(),true);
            if (vesa_mount_panel_enabled && vesa_fixed() && vesa_panel_use_joinery)
                side_joint_features(vesa_mount_origin_y(),vesa_mount_origin_z_local(),vesa_mount_panel_h(),active_screen_angle(),true);
        }
    }
}

module vesa_adjustable_side_mount_cutouts() {
    if (vesa_mount_panel_enabled && vesa_adjustable() && vesa_adjust_side_holes_enabled) {
        for (i=[0:1]) {
            u = vesa_adjust_rail_y0() + vesa_adjust_bolt_y_local(i);
            z = vesa_adjust_fixed_bolt_local_z();
            translate([screen_local_to_side_y(u,z),screen_local_to_side_z(u,z)])
                circle(d=vesa_adjust_bolt_hole_diameter,$fn=40);
        }
    }
}

module side_panel_2d() {
    difference() {
        if (is_arcade()) arcade_side_outline_2d();
        else polygon(points=side_profile_points());

        side_panel_joinery_cutouts();
        vesa_adjustable_side_mount_cutouts();

        if (is_vpin() && pinball_side_buttons) {
            fy = pinball_flipper_from_front;
            fz = vpin_top_at(fy) - pinball_flipper_from_top;
            translate([fy,fz]) circle(d=pinball_flipper_hole_diameter,$fn=48);
        }
    }
}

// ---------- Clean single-part exporter ----------
module export_named_part(material="wood", name="control_panel") {
    if (material == "wood") {
        if (name == "left_side" || name == "right_side") side_panel_2d();
        else if (name == "control_panel") control_panel_2d(false);
        else if (name == "control_fascia") control_fascia_panel_2d();
        else if (name == "admin_panel") admin_panel_2d();
        else if (name == "keyboard_drawer_front") keyboard_drawer_front_2d();
        else if (name == "keyboard_drawer_shelf") keyboard_drawer_shelf_2d();
        else if (name == "screen_panel") screen_panel_2d(false);
        else if (name == "vesa_mount_panel") vesa_mount_panel_2d();
        else if (name == "vesa_adjust_rail") vesa_adjust_rail_2d();
        else if (name == "front_panel") front_panel_2d();
        else if (name == "rear_panel") rear_panel_2d();
        else if (name == "rear_service_door") rear_service_door_2d();
        else if (name == "coin_door") coin_door_2d();
        else if (name == "bottom_panel") bottom_panel_2d();
        else if (name == "top_panel") top_panel_2d();
        else if (name == "marquee_panel") marquee_panel_2d();
        else if (name == "speaker_panel") speaker_panel_2d();
        else if (name == "speaker_baffle") speaker_baffle_panel_2d();
        else if (name == "vpin_backbox_side") vpin_backbox_side_2d();
        else if (name == "vpin_backbox_front") vpin_backbox_front_2d(false);
        else if (name == "vpin_backbox_rear") vpin_backbox_rear_2d();
        else if (name == "vpin_backbox_top") vpin_backbox_top_2d();
        else if (name == "vpin_backbox_bottom") vpin_backbox_bottom_2d();
        else assert(false, str("Unknown wood part_name: ", name));
    } else if (material == "plexi") {
        if (name == "control_plexi") control_plexi_2d();
        else if (name == "screen_plexi") screen_plexi_2d();
        else if (name == "marquee_plexi") marquee_plexi_2d();
        else if (name == "vpin_backbox_plexi") vpin_backbox_plexi_2d();
        else assert(false, str("Unknown plexi part_name: ", name));
    } else {
        assert(false, str("Unknown part_material: ", material));
    }
}

// ---------- Overview cut layouts ----------
// These are convenient visual layouts, not guaranteed optimal nesting on a specific sheet.
module wood_sheet_2d() {
    side_x_span = is_arcade() ? cab_d()+cp_overhang() : cab_d();
    g = layout_gap;

    // Sides
    translate([is_arcade() ? cp_overhang() : 0,0]) side_panel_2d();
    translate([side_x_span+g + (is_arcade() ? cp_overhang() : 0),0]) side_panel_2d();

    // Rectangular parts to the right
    rx = 2*side_x_span + 2*g;
    translate([rx,0]) control_panel_2d(false);
    translate([rx,cp_depth()+g]) screen_panel_2d(false);
    screen_h_for_sheet = is_vpin()?vpin_playfield_len():arcade_screen_panel_len();
    vesa_y_sheet = cp_depth()+g + screen_h_for_sheet + g;
    if (vesa_mount_panel_enabled)
        translate([rx + (vesa_adjustable()?t():0),vesa_y_sheet]) vesa_mount_panel_2d();
    rail_y_sheet = vesa_y_sheet + (vesa_mount_panel_enabled ? vesa_mount_panel_h()+g : 0);
    if (vesa_mount_panel_enabled && vesa_adjustable()) {
        translate([rx,rail_y_sheet]) vesa_adjust_rail_2d();
        translate([rx+vesa_adjust_rail_depth()+g,rail_y_sheet]) vesa_adjust_rail_2d();
    }
    front_y_sheet = rail_y_sheet + (vesa_mount_panel_enabled && vesa_adjustable() ? vesa_adjust_rail_h()+g : 0);
    translate([rx,front_y_sheet]) front_panel_2d();
    extra_y = front_y_sheet + front_panel_h() + g;
    if (is_arcade() && preset_control_fascia_enabled())
        translate([rx,extra_y]) control_fascia_panel_2d();
    if (is_arcade() && active_admin_panel_enabled())
        translate([rx,extra_y + (preset_control_fascia_enabled()?active_control_fascia_height()+g:0)]) admin_panel_2d();
    if (is_arcade() && active_keyboard_drawer_enabled()) {
        ky = extra_y + (preset_control_fascia_enabled()?active_control_fascia_height()+g:0) + (active_admin_panel_enabled()?active_admin_panel_height()+g:0);
        translate([rx,ky]) keyboard_drawer_front_2d();
        translate([rx,ky+active_keyboard_drawer_height()+g]) keyboard_drawer_shelf_2d();
    }

    rx2 = rx + inner_w() + g;
    translate([rx2,0]) rear_panel_2d();
    translate([rx2,rear_panel_h()+g]) rotate(90) bottom_panel_2d();
    if (is_arcade()) {
        translate([rx2 + cab_d()+g,0]) top_panel_2d();
        if (marquee_on())
            translate([rx2 + cab_d()+g,top_panel_depth()+g]) marquee_panel_2d();
        if (speaker_on())
            translate([rx2 + cab_d()+g,top_panel_depth()+g + (marquee_on()?marquee_panel_h()+g:0)]) speaker_panel_2d();
        if (active_speaker_baffle_enabled())
            translate([rx2 + cab_d()+g,top_panel_depth()+g + (marquee_on()?marquee_panel_h()+g:0) + (speaker_on()?arcade_speaker_panel_depth()+g:0)]) speaker_baffle_panel_2d();
        if (active_coin_door_enabled())
            translate([rx2 + cab_d()+inner_w()+2*g,0]) coin_door_2d();
        if (active_rear_service_door_enabled())
            translate([rx2 + cab_d()+inner_w()+2*g,active_coin_door_enabled()?active_coin_door_height()+g:0]) rear_service_door_2d();
    }
    if (is_vpin() && active_vpin_backbox_enabled()) {
        bx=rx2 + cab_d()+2*g;
        translate([bx,0]) vpin_backbox_side_2d();
        translate([bx+active_vpin_backbox_depth()+g,0]) vpin_backbox_side_2d();
        translate([bx,active_vpin_backbox_height()+g]) vpin_backbox_front_2d(false);
        translate([bx,2*active_vpin_backbox_height()+2*g]) vpin_backbox_rear_2d();
    }
}

module plexi_sheet_2d() {
    g = layout_gap;
    control_plexi_2d();
    translate([0,cp_depth()+g]) screen_plexi_2d();
    if (marquee_on())
        translate([inner_w()+g,0]) marquee_plexi_2d();
    if (is_vpin() && active_vpin_backbox_enabled())
        translate([inner_w()+g,marquee_on()?marquee_panel_h()+g:0]) vpin_backbox_plexi_2d();
}

// ---------- 3D helpers ----------
// Maps a 2D (depth,height) profile to world (Y,Z), extruded along world X.
module extrude_profile_along_x(thickness) {
    multmatrix([
        [0,0,1,0],
        [1,0,0,0],
        [0,1,0,0],
        [0,0,0,1]
    ]) linear_extrude(height=thickness) children();
}

// Maps a rail drawing whose X axis is screen-normal depth and whose Y axis
// is screen-plane height into local 3D Y/Z, extruded along local X.
module extrude_vesa_rail_along_x(thickness) {
    multmatrix([
        [0,0,1,0],
        [0,1,0,0],
        [1,0,0,0],
        [0,0,0,1]
    ]) linear_extrude(height=thickness) children();
}

module plate_xy(thickness) {
    linear_extrude(height=thickness) children();
}

// Maps a front/rear 2D panel (width,height) to world X/Z and extrudes in +Y.
module extrude_panel_along_y(thickness) {
    multmatrix([
        [1,0,0,0],
        [0,0,1,0],
        [0,1,0,0],
        [0,0,0,1]
    ]) linear_extrude(height=thickness) children();
}

module screen_normal_arrow(x0,y0,z0,angle_deg,len=110) {
    // Local screen normal for a panel rotated about X by angle_deg.
    // A small visual aid: from screen center toward the player/upward-facing direction.
    // Normal chosen toward -Y and +Z for positive recline.
    ny = -sin(angle_deg);
    nz = cos(angle_deg);
    color([1,0.25,0.15]) {
        translate([x0,y0,z0]) sphere(r=6,$fn=24);
        hull() {
            translate([x0,y0,z0]) sphere(r=3,$fn=16);
            translate([x0,y0+ny*len,z0+nz*len]) sphere(r=3,$fn=16);
        }
    }
}

module arcade_assembly() {
    W=cab_w(); IW=inner_w(); D=cab_d(); H=cab_h(); T=t(); C=cp_z(); O=cp_overhang();
    sang=arcade_screen_panel_angle();
    sy0=arcade_screen_lower_y();
    sz0=arcade_screen_lower_z();

    // Side panels
    color([0.12,0.12,0.13]) translate([0,0,0]) extrude_profile_along_x(T) side_panel_2d();
    color([0.12,0.12,0.13]) translate([W-T,0,0]) extrude_profile_along_x(T) side_panel_2d();

    // Bottom
    color([0.18,0.18,0.19]) translate([T,0,T]) plate_xy(T) bottom_panel_2d();

    // Lower front and back (actual CNC cutouts are shown in preview).
    color([0.16,0.16,0.17]) translate([T,0,0]) extrude_panel_along_y(T) front_panel_2d();
    color([0.16,0.16,0.17]) translate([T,D-T,0]) extrude_panel_along_y(T) rear_panel_2d();

    // Control-panel front fascia.
    if (preset_control_fascia_enabled())
        color([0.10,0.10,0.11])
            translate([T,cp_front_y(),C-active_control_fascia_height()])
                extrude_panel_along_y(T) control_fascia_panel_2d();

    // Optional admin panel below the monitor.
    if (active_admin_panel_enabled()) {
        az_top=min(sz0-4,cp_rear_z()+active_admin_panel_height());
        color([0.11,0.11,0.12])
            translate([T,cp_rear_y(),az_top-active_admin_panel_height()])
                extrude_panel_along_y(T) admin_panel_2d();
    }

    // Keyboard drawer front and simple shelf.
    if (active_keyboard_drawer_enabled()) {
        kx=T+(IW-active_keyboard_drawer_width())/2;
        kz=active_keyboard_drawer_bottom_z();
        color([0.13,0.13,0.14])
            translate([kx,0,kz]) extrude_panel_along_y(T) keyboard_drawer_front_2d();
        color([0.15,0.15,0.16])
            translate([kx,T,kz+active_keyboard_drawer_height()-T]) plate_xy(T) keyboard_drawer_shelf_2d();
    }

    if (active_coin_door_enabled()) {
        dx=T+(IW-active_coin_door_width())/2;
        color([0.08,0.08,0.09])
            translate([dx,0,active_coin_door_bottom_z()]) extrude_panel_along_y(T) coin_door_2d();
    }

    if (active_rear_service_door_enabled()) {
        dx=T+(IW-active_rear_service_door_width())/2;
        color([0.10,0.10,0.11])
            translate([dx,D-T,active_rear_service_door_bottom_z()]) extrude_panel_along_y(T) rear_service_door_2d();
    }

    // Control panel
    color([0.10,0.10,0.11])
        translate([T,cp_front_y(),C])
            rotate([active_control_panel_angle(),0,0])
                plate_xy(T) control_panel_2d(false);

    // Control plexi
    if (show_plexi_preview)
        color([0.65,0.85,1.0,0.25])
            translate([T,cp_front_y(),C])
                rotate([active_control_panel_angle(),0,0])
                    translate([0,0,T+0.5]) plate_xy(plexi_thickness) control_plexi_2d();

    // Monitor/bezel panel: bottom edge near control deck; top leans rearward.
    color([0.08,0.08,0.09])
        translate([T,sy0,sz0])
            rotate([sang,0,0])
                plate_xy(T) screen_panel_2d(false);

    if (show_plexi_preview)
        color([0.55,0.80,1.0,0.22])
            translate([T,sy0,sz0])
                rotate([sang,0,0])
                    translate([0,0,T+0.5]) plate_xy(plexi_thickness) screen_plexi_2d();

    if (show_screen_preview) {
        // Screen face reference aligned exactly to the screen-panel cutout center.
        color([0.015,0.015,0.02])
            translate([T,sy0,sz0])
                rotate([sang,0,0])
                    translate([(IW-sw())/2,active_screen_tb_margin(),T+plexi_thickness+1])
                        cube([sw(),sh(),2]);
    }

    // Internal VESA carrier. Fixed mode mounts directly to the cabinet sides;
    // adjustable mode uses a carrier plus two sliding side rails.
    if (vesa_mount_panel_enabled)
        translate([T,sy0,sz0])
            rotate([sang,0,0]) {
                color([0.30,0.22,0.14])
                    translate([vesa_adjustable()?T:0,vesa_mount_local_y0(),vesa_mount_local_z0()])
                        plate_xy(T) vesa_mount_panel_2d();

                if (vesa_adjustable()) {
                    color([0.24,0.18,0.12]) {
                        translate([0,vesa_adjust_rail_y0(),vesa_adjust_rail_local_z0()])
                            extrude_vesa_rail_along_x(T) vesa_adjust_rail_2d();
                        translate([IW-T,vesa_adjust_rail_y0(),vesa_adjust_rail_local_z0()])
                            extrude_vesa_rail_along_x(T) vesa_adjust_rail_2d();
                    }

                    if (show_vesa_adjustment_envelope) {
                        color([0.25,0.75,1.0,0.12])
                            translate([T,vesa_mount_local_y0(),vesa_mount_local_z0_at(vesa_adjust_min_setback)])
                                plate_xy(T) vesa_mount_panel_2d();
                        color([1.0,0.55,0.20,0.12])
                            translate([T,vesa_mount_local_y0(),vesa_mount_local_z0_at(vesa_adjust_max_setback)])
                                plate_xy(T) vesa_mount_panel_2d();
                    }
                }
            }

    // Classic/curved head. The marquee is the outside front face and covers
    // the front edges of both the top cap and speaker shelf. With
    // head_panel_gap=0 all three pieces meet with no visible reveal.
    if (marquee_on()) {
        mf = arcade_marquee_front_y();
        mb = arcade_marquee_bottom_z();
        head_y = arcade_head_inner_front_y();

        // Marquee face occupies y=mf..mf+T and the full outside head height
        // from the speaker-shelf lower face (mb) through the top-cap top face.
        color([0.11,0.11,0.12])
            translate([T,mf,mb]) cube([IW,T,marquee_panel_h()]);

        if (show_plexi_preview)
            color([0.65,0.25,0.20,0.28])
                translate([T,mf-0.5,mb])
                    rotate([90,0,0])
                        plate_xy(plexi_thickness) marquee_plexi_2d();

        if (speaker_on()) {
            color([0.09,0.09,0.10])
                translate([T,arcade_speaker_panel_y(),arcade_speaker_panel_z()])
                    plate_xy(T) speaker_panel_2d();
        }

        if (active_speaker_baffle_enabled())
            color([0.09,0.09,0.10])
                translate([T,mf,mb-active_speaker_baffle_height()])
                    extrude_panel_along_y(T) speaker_baffle_panel_2d();

        color([0.14,0.14,0.15])
            translate([T,head_y,H-T]) plate_xy(T) top_panel_2d();
    } else {
        // Small top cap for viewlix-style cabinets.
        top_y = max(30,arcade_screen_upper_y()-25);
        color([0.14,0.14,0.15])
            translate([T,top_y,H-T]) plate_xy(T) top_panel_2d();
    }

    if (show_screen_normal_preview) {
        center_y = sy0 + arcade_screen_panel_len()/2*cos(sang);
        center_z = sz0 + arcade_screen_panel_len()/2*sin(sang);
        screen_normal_arrow(W/2,center_y,center_z+T+plexi_thickness+4,sang,110);
    }
}

module vpin_assembly() {
    W=cab_w(); IW=inner_w(); D=cab_d(); T=t(); Z0=vpin_body_z(); FH=vpin_front_h(); RH=vpin_rear_h();

    // Side cabinet walls
    color([0.12,0.12,0.13]) translate([0,0,Z0]) extrude_profile_along_x(T) side_panel_2d();
    color([0.12,0.12,0.13]) translate([W-T,0,Z0]) extrude_profile_along_x(T) side_panel_2d();

    // Bottom, front, rear
    color([0.16,0.16,0.17]) translate([T,0,Z0]) plate_xy(T) bottom_panel_2d();
    color([0.16,0.16,0.17]) translate([T,0,Z0]) extrude_panel_along_y(T) front_panel_2d();
    color([0.16,0.16,0.17]) translate([T,D-T,Z0]) extrude_panel_along_y(T) rear_panel_2d();

    // Optional simple leg preview for a full-size virtual pinball cabinet.
    if (is_full_vpin()) {
        leg=42;
        for (x=[T+25,W-T-25-leg])
            for (y=[55,D-95])
                color([0.25,0.25,0.25]) translate([x,y,0]) cube([leg,leg,Z0]);
    }

    // Front control deck
    cp_y = -35;
    cp_z0 = Z0 + FH;
    color([0.10,0.10,0.11])
        translate([T,cp_y,cp_z0])
            rotate([vpin_top_angle(),0,0])
                plate_xy(T) control_panel_2d(false);

    if (show_plexi_preview)
        color([0.65,0.85,1.0,0.25])
            translate([T,cp_y,cp_z0])
                rotate([vpin_top_angle(),0,0])
                    translate([0,0,T+0.5]) plate_xy(plexi_thickness) control_plexi_2d();

    // Playfield deck starts after the front apron along the sloped top.
    pf_y = active_vpin_front_apron()*cos(vpin_top_angle());
    pf_z = Z0 + FH + active_vpin_front_apron()*sin(vpin_top_angle());
    color([0.08,0.08,0.09])
        translate([T,pf_y,pf_z])
            rotate([vpin_top_angle(),0,0])
                plate_xy(T) screen_panel_2d(false);

    if (show_plexi_preview)
        color([0.55,0.80,1.0,0.22])
            translate([T,pf_y,pf_z])
                rotate([vpin_top_angle(),0,0])
                    translate([0,0,T+0.5]) plate_xy(plexi_thickness) screen_plexi_2d();

    if (show_screen_preview)
        color([0.015,0.015,0.02])
            translate([T,pf_y,pf_z])
                rotate([vpin_top_angle(),0,0])
                    translate([(IW-sw())/2,active_screen_tb_margin(),T+plexi_thickness+1])
                        cube([sw(),sh(),2]);

    if (vesa_mount_panel_enabled)
        translate([T,pf_y,pf_z])
            rotate([vpin_top_angle(),0,0]) {
                color([0.30,0.22,0.14])
                    translate([vesa_adjustable()?T:0,vesa_mount_local_y0(),vesa_mount_local_z0()])
                        plate_xy(T) vesa_mount_panel_2d();

                if (vesa_adjustable()) {
                    color([0.24,0.18,0.12]) {
                        translate([0,vesa_adjust_rail_y0(),vesa_adjust_rail_local_z0()])
                            extrude_vesa_rail_along_x(T) vesa_adjust_rail_2d();
                        translate([IW-T,vesa_adjust_rail_y0(),vesa_adjust_rail_local_z0()])
                            extrude_vesa_rail_along_x(T) vesa_adjust_rail_2d();
                    }

                    if (show_vesa_adjustment_envelope) {
                        color([0.25,0.75,1.0,0.12])
                            translate([T,vesa_mount_local_y0(),vesa_mount_local_z0_at(vesa_adjust_min_setback)])
                                plate_xy(T) vesa_mount_panel_2d();
                        color([1.0,0.55,0.20,0.12])
                            translate([T,vesa_mount_local_y0(),vesa_mount_local_z0_at(vesa_adjust_max_setback)])
                                plate_xy(T) vesa_mount_panel_2d();
                    }
                }
            }

    // Optional virtual-pinball backbox.
    if (active_vpin_backbox_enabled()) {
        BBW=active_vpin_backbox_width(); BBH=active_vpin_backbox_height(); BBD=active_vpin_backbox_depth();
        BBX=vpin_backbox_x0(); BBY=vpin_backbox_front_y(); BBZ=vpin_backbox_bottom_z(); BIW=vpin_backbox_inner_w();

        color([0.12,0.12,0.13]) translate([BBX,BBY,BBZ]) extrude_profile_along_x(T) vpin_backbox_side_2d();
        color([0.12,0.12,0.13]) translate([BBX+BBW-T,BBY,BBZ]) extrude_profile_along_x(T) vpin_backbox_side_2d();
        color([0.08,0.08,0.09]) translate([BBX+T,BBY,BBZ]) extrude_panel_along_y(T) vpin_backbox_front_2d(false);
        color([0.14,0.14,0.15]) translate([BBX+T,BBY+BBD-T,BBZ]) extrude_panel_along_y(T) vpin_backbox_rear_2d();
        color([0.14,0.14,0.15]) translate([BBX+T,BBY,BBZ]) plate_xy(T) vpin_backbox_bottom_2d();
        color([0.14,0.14,0.15]) translate([BBX+T,BBY,BBZ+BBH-T]) plate_xy(T) vpin_backbox_top_2d();

        if (show_plexi_preview)
            color([0.55,0.80,1.0,0.20])
                translate([BBX+T,BBY-plexi_thickness-0.5,BBZ])
                    extrude_panel_along_y(plexi_thickness) vpin_backbox_plexi_2d();
    }
}

module assembly() {
    if (is_arcade()) arcade_assembly();
    else vpin_assembly();
}

// ---------- Main ----------
if (output_mode == "assembly") assembly();
else if (output_mode == "wood_sheet") wood_sheet_2d();
else if (output_mode == "plexi_sheet") plexi_sheet_2d();
else if (output_mode == "part") export_named_part(part_material,part_name);
else assert(false, str("Unknown output_mode: ", output_mode));