// Hardware mounting templates.
// Values are NOMINAL and must be checked against the vendor's drawing before
// cutting; mounting patterns change between production runs and plate styles.
//   joystick: [name, shaft hole, mount dx, mount dy, mount hole diameter]
//   trackball: [name, cutout diameter, mount spacing (square), mount hole diameter]
//   button:   [name, panel hole diameter, flange diameter]

joystick_templates = [
  ["sanwa_jlf",        24, 85.0, 40.0, 4.5],   // JLF-P1 flat plate, nominal; verify
  ["happ_competition", 32, 63.5, 82.5, 5.0],   // approx, verify against the Happ drawing
];
trackball_templates = [
  ["u_trak", 82.0, 81.3, 6.0],                 // Ultimarc U-Trak: 82 mm cutout, 3.2 in spacing, 1/4 in holes
];
button_templates = [
  ["japanese_30", 30.0, 33.5],
  ["japanese_24", 24.0, 27.5],
  ["american_28", 28.6, 34.0],                 // 1 1/8 in hole
];

function template_row(table, name) = let(h = [for (r = table) if (r[0] == name) r]) len(h) == 0 ? undef : h[0];

function joystick_spec() =
    let(r = template_row(joystick_templates, c_joystick_template))
    is_undef(r) ? ["custom", joystick_shaft_hole, joystick_mount_spacing_x, joystick_mount_spacing_y, joystick_mount_hole_diameter] : r;
function trackball_spec() =
    let(r = template_row(trackball_templates, c_trackball_template))
    is_undef(r) ? ["custom", trackball_cutout_diameter, trackball_mount_spacing, trackball_mount_hole_diameter] : r;
function button_spec() =
    let(r = template_row(button_templates, c_button_type))
    is_undef(r) ? ["custom", 30, 33.5] : r;

function js_shaft_hole() = joystick_spec()[1];
function js_mount_dx() = joystick_spec()[2];
function js_mount_dy() = joystick_spec()[3];
function js_mount_hole() = joystick_spec()[4];
function tb_cutout() = trackball_spec()[1];
function tb_mount_spacing() = trackball_spec()[2];
function tb_mount_hole() = trackball_spec()[3];
function action_button_hole() = button_spec()[1];
function action_button_flange() = button_spec()[2];
