// Reference-plan presets as a data table.
// Each entry: [name, [[parameter, value, group], ...]]
// group is one of "geometry", "material", "screen", "controls" and maps to the
// preset_use_* switches in the main file. A parameter not listed keeps the
// value from the main file. Values marked "approx" were not legible in the
// source drawing and are estimates.

preset_table = [
  ["tinyarcade_bartop", [
    ["cabinet_style", "bartop", "geometry"],
    ["cabinet_width", 500, "geometry"],          // 470 inner + 2 x 15
    ["cabinet_depth", 420, "geometry"],
    ["bartop_control_height", 160, "geometry"],
    ["bartop_control_overhang", 0, "geometry"],
    ["control_panel_depth", 110, "geometry"],
    ["control_panel_angle", 10, "geometry"],
    ["control_fascia_height", 70, "geometry"],
    ["kick_drop", 0, "geometry"],
    ["screen_recline_angle", 12, "geometry"],
    ["screen_top_bottom_margin", 10, "geometry"],
    ["screen_side_margin", 35, "geometry"],
    ["control_to_screen_clearance", 18, "geometry"],
    ["screen_gap_above_control", 5, "geometry"],
    ["bartop_marquee_height", 62, "geometry"],
    ["marquee_forward_projection", 55, "geometry"],
    ["bartop_neck_rise", 40, "geometry"],
    ["marquee_shelf_depth", 100, "geometry"],
    ["side_corner_radius", 0, "geometry"],
    ["rear_service_door_enabled", false, "geometry"],
    ["material_thickness", 15, "material"],
    ["screen_width", 305, "screen"],
    ["screen_height", 220, "screen"],
    ["players", 1, "controls"],
    ["buttons_per_player", 6, "controls"],
    ["aux_button_count", 2, "controls"],
    ["aux_button_location", "fascia", "controls"],
    ["trackball_enabled", false, "controls"]
  ]],
  ["koenigs_mame", [
    ["cabinet_style", "standup", "geometry"],
    ["cabinet_width", 636, "geometry"],
    ["cabinet_depth", 500, "geometry"],
    ["cabinet_height", 1800, "geometry"],
    ["standup_control_height", 820, "geometry"],
    ["standup_control_overhang", 100, "geometry"],
    ["control_panel_depth", 250, "geometry"],
    ["control_panel_angle", 6, "geometry"],
    ["screen_recline_angle", 12, "geometry"],
    ["standup_marquee_height", 150, "geometry"],
    ["keyboard_drawer_enabled", true, "geometry"],
    ["keyboard_drawer_width", 500, "geometry"],
    ["keyboard_drawer_bottom_z", 520, "geometry"],   // front panel is only 645 mm tall under the fascia and kick
    ["material_thickness", 18, "material"],
    ["screen_width", 400, "screen"],                // approx
    ["screen_height", 300, "screen"],               // approx
    ["players", 2, "controls"]
  ]],
  ["compact_1600", [
    ["cabinet_style", "standup", "geometry"],
    ["cabinet_width", 636, "geometry"],
    ["cabinet_depth", 500, "geometry"],
    ["cabinet_height", 1600, "geometry"],
    ["standup_control_height", 718, "geometry"],
    ["standup_control_overhang", 80, "geometry"],
    ["control_panel_depth", 220, "geometry"],
    ["control_panel_angle", 4, "geometry"],
    ["screen_recline_angle", 9, "geometry"],
    ["standup_marquee_height", 110, "geometry"],
    ["material_thickness", 18, "material"],
    ["screen_width", 480, "screen"],                // approx
    ["screen_height", 270, "screen"],               // approx
    ["players", 2, "controls"]
  ]],
  ["asteroids", [
    ["cabinet_style", "standup", "geometry"],
    ["cabinet_width", 736, "geometry"],          // drawing: 700 + 18 + 18
    ["cabinet_depth", 550, "geometry"],
    ["cabinet_height", 1892, "geometry"],
    ["standup_control_height", 1050, "geometry"],  // as drawn; high for most players, see README
    ["standup_control_overhang", 100, "geometry"],
    ["control_panel_depth", 251, "geometry"],
    ["control_panel_angle", 6, "geometry"],
    ["control_fascia_height", 150, "geometry"],
    ["screen_recline_angle", 10, "geometry"],
    ["screen_top_bottom_margin", 50, "geometry"],
    ["screen_side_margin", 75, "geometry"],
    ["screen_gap_above_control", 55, "geometry"],
    ["standup_marquee_height", 216, "geometry"],
    ["marquee_forward_projection", 100, "geometry"],
    ["keyboard_drawer_enabled", true, "geometry"],
    ["keyboard_drawer_width", 520, "geometry"],
    ["keyboard_drawer_height", 100, "geometry"],
    ["keyboard_drawer_bottom_z", 680, "geometry"],  // drawn at 850, but that lands in the fascia zone; 680 keeps it on the front panel
    ["keyboard_drawer_depth", 400, "geometry"],
    ["coin_door_enabled", true, "geometry"],
    ["coin_door_bottom_z", 470, "geometry"],
    ["rear_service_door_enabled", true, "geometry"],
    ["rear_service_door_width", 400, "geometry"],
    ["rear_service_door_height", 1000, "geometry"],
    ["rear_service_door_bottom_z", 180, "geometry"],
    ["material_thickness", 18, "material"],
    ["screen_width", 510, "screen"],
    ["screen_height", 290, "screen"],
    ["players", 2, "controls"]
  ]],
  ["classic_80s", [
    ["cabinet_style", "standup", "geometry"],
    ["cabinet_width", 650, "geometry"],
    ["cabinet_depth", 650, "geometry"],
    ["cabinet_height", 1850, "geometry"],
    ["standup_control_height", 930, "geometry"],
    ["standup_control_overhang", 80, "geometry"],
    ["control_panel_depth", 250, "geometry"],
    ["control_panel_angle", 5, "geometry"],
    ["screen_recline_angle", 10, "geometry"],
    ["standup_marquee_height", 200, "geometry"],
    ["material_thickness", 18, "material"],
    ["screen_width", 500, "screen"],                // approx, 25 in 4:3
    ["screen_height", 375, "screen"],
    ["players", 2, "controls"]
  ]],
  ["we_build_stuff", [
    ["cabinet_style", "standup", "geometry"],
    ["cabinet_width", 650, "geometry"],
    ["cabinet_depth", 500, "geometry"],
    ["cabinet_height", 1850, "geometry"],
    ["standup_control_height", 960.2, "geometry"],
    ["standup_control_overhang", 95.1, "geometry"],
    ["control_panel_depth", 198.9, "geometry"],
    ["control_panel_angle", 5, "geometry"],
    ["control_fascia_height", 110, "geometry"],
    ["screen_recline_angle", 10, "geometry"],
    ["control_to_screen_clearance", 20, "geometry"],
    ["screen_gap_above_control", 60, "geometry"],
    ["standup_marquee_height", 224, "geometry"],
    ["marquee_forward_projection", 80, "geometry"],
    ["side_corner_radius", 0, "geometry"],
    ["material_thickness", 19.05, "material"],
    ["screen_width", 500, "screen"],
    ["screen_height", 375, "screen"],
    ["players", 2, "controls"]
  ]],
  ["vpin_731x1308", [
    ["cabinet_style", "vpin", "geometry"],
    ["cabinet_width", 731, "geometry"],
    ["cabinet_depth", 1308, "geometry"],
    ["vpin_front_body_height", 330, "geometry"],
    ["vpin_rear_body_height", 470, "geometry"],
    ["vpin_leg_height", 650, "geometry"],
    ["vpin_front_apron", 120, "geometry"],         // a 49 in screen only fits a 1308 deep body with a short apron,
    ["vpin_rear_step", 60, "geometry"],            // a short rear deck and tight top/bottom margins
    ["screen_top_bottom_margin", 25, "geometry"],
    ["vpin_backbox_enabled", true, "geometry"],
    ["vpin_backbox_height", 520, "geometry"],
    ["vpin_backbox_display_width", 600, "geometry"],
    ["vpin_backbox_display_height", 335, "geometry"],
    ["material_thickness", 18, "material"],
    ["screen_width", 1073, "screen"],              // 49 in 16:9 active area, drawn portrait
    ["screen_height", 604, "screen"],
    ["players", 1, "controls"],
    ["include_joysticks", false, "controls"],
    ["trackball_enabled", false, "controls"]
  ]]
];

function preset_index(name) = [for (i = [0:len(preset_table)-1]) if (preset_table[i][0] == name) i];
function preset_active() = design_preset != "custom";
function preset_group_enabled(g) =
    g == "geometry" ? preset_use_geometry :
    g == "material" ? preset_use_material :
    g == "screen"   ? preset_use_screen :
    g == "controls" ? preset_use_controls : true;

// Value of parameter `key` from the active preset, or undef.
function preset_value(key) =
    let(idx = preset_index(design_preset))
    len(idx) == 0 ? undef :
    let(rows = preset_table[idx[0]][1],
        hits = [for (r = rows) if (r[0] == key && preset_group_enabled(r[2])) r[1]])
    len(hits) == 0 ? undef : hits[0];

// cfg(key, user_value): the preset value when the preset defines it, else the user's value.
function cfg(key, user_value) = let(p = preset_value(key)) is_undef(p) ? user_value : p;

assert(design_preset == "custom" || len(preset_index(design_preset)) == 1,
       str("Unknown design_preset: ", design_preset));
