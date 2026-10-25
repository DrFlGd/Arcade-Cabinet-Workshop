// Derived geometry.
// Side-view coordinates: y = depth from the lower front panel face (positive
// toward the rear), z = height above the floor (arcade) or above the body
// bottom (pinball). The cabinet is extruded along world X between two side
// panels of thickness T; cross panels are IW wide.
//
// The side profile is a closed polyline of FACES walked counter-clockwise
// (interior on the left). Each face is either open or carries a cross panel
// whose outer face lies `lip` inside the profile line. Neighbouring panels are
// trimmed to butt against each other, and the side panel polygon is simply the
// list of face corners. Nothing is hand-tuned: change a parameter and every
// panel, slot and outline follows.

// ---------- Resolved configuration (preset-aware) ----------
c_style = cfg("cabinet_style", cabinet_style);
c_is_vpin = c_style == "vpin" || c_style == "vpin_bartop";
c_is_arcade = !c_is_vpin;
c_is_standup = c_style == "standup";
c_is_bartop = c_style == "bartop";
c_full_vpin = c_style == "vpin";

T  = cfg("material_thickness", material_thickness);
PT = plexi_thickness;
c_inset = cfg("panel_inset", panel_inset);
c_tool_r = tool_diameter / 2;

c_players = cfg("players", players);
c_buttons = cfg("buttons_per_player", buttons_per_player);
c_joysticks = cfg("include_joysticks", include_joysticks);
c_trackball = cfg("trackball_enabled", trackball_enabled);
c_aux_count = cfg("aux_button_count", aux_button_count);
c_aux_loc = cfg("aux_button_location", aux_button_location);
c_joystick_template = cfg("joystick_template", joystick_template);
c_trackball_template = cfg("trackball_template", trackball_template);
c_button_type = cfg("button_type", button_type);
c_button_layout = cfg("button_layout", button_layout);
c_cpd = cfg("control_panel_depth", control_panel_depth);
c_cpa = cfg("control_panel_angle", control_panel_angle);

c_screen_w_raw = cfg("screen_width", screen_width);
c_screen_h_raw = cfg("screen_height", screen_height);
c_orientation = cfg("screen_orientation", screen_orientation);
c_portrait = c_orientation == "portrait" || (c_orientation == "auto" && c_is_vpin);
SW = c_portrait ? c_screen_h_raw : c_screen_w_raw;   // across the cabinet
SH = c_portrait ? c_screen_w_raw : c_screen_h_raw;   // along the screen panel
c_recline = cfg("screen_recline_angle", screen_recline_angle);
c_margin_tb = cfg("screen_top_bottom_margin", screen_top_bottom_margin);
c_margin_side = cfg("screen_side_margin", screen_side_margin);
c_scr_len = SH + 2 * c_margin_tb;
c_scr_open_w = SW + 2 * screen_cutout_clearance;
c_scr_open_h = SH + 2 * screen_cutout_clearance;
c_scr_clearance = cfg("control_to_screen_clearance", control_to_screen_clearance);
c_scr_gap = cfg("screen_gap_above_control", screen_gap_above_control);

c_C = c_is_standup ? cfg("standup_control_height", standup_control_height) : cfg("bartop_control_height", bartop_control_height);
c_O = c_is_standup ? cfg("standup_control_overhang", standup_control_overhang) : cfg("bartop_control_overhang", bartop_control_overhang);
c_fas_h = c_is_standup ? cfg("control_fascia_height", control_fascia_height) : cfg("bartop_control_fascia_height", bartop_control_fascia_height);
c_kick_drop = c_is_standup && c_O > 0 ? cfg("kick_drop", kick_drop) : 0;   // bartops sit on a counter: vertical front, no kick
c_lift = cfg("bottom_lift", bottom_lift);
c_corner_r = cfg("side_corner_radius", side_corner_radius);

c_marquee_on = c_is_arcade && marquee_mode != "off";
c_mq_h = c_marquee_on ? (c_is_standup ? cfg("standup_marquee_height", standup_marquee_height) : cfg("bartop_marquee_height", bartop_marquee_height)) : 0;
c_mq_proj = cfg("marquee_forward_projection", marquee_forward_projection);
c_neck_rise_user = c_is_standup ? cfg("standup_neck_rise", standup_neck_rise) : cfg("bartop_neck_rise", bartop_neck_rise);
c_mq_shelf = cfg("marquee_shelf_depth", marquee_shelf_depth);

c_vpin_FH = c_full_vpin ? cfg("vpin_front_body_height", vpin_front_body_height) : cfg("vpin_bartop_front_height", vpin_bartop_front_height);
c_vpin_RH = c_full_vpin ? cfg("vpin_rear_body_height", vpin_rear_body_height) : cfg("vpin_bartop_rear_height", vpin_bartop_rear_height);
c_vpin_Z0 = c_full_vpin ? cfg("vpin_leg_height", vpin_leg_height) : 0;
c_vpin_step = cfg("vpin_rear_step", vpin_rear_step);
c_vpin_apron = cfg("vpin_front_apron", vpin_front_apron);
c_backbox_on = c_is_vpin && cfg("vpin_backbox_enabled", vpin_backbox_enabled);

c_coin_door = c_is_arcade && cfg("coin_door_enabled", coin_door_enabled);
c_coin_bottom = cfg("coin_door_bottom_z", coin_door_bottom_z);
c_kd_on = c_is_arcade && cfg("keyboard_drawer_enabled", keyboard_drawer_enabled);
c_kd_w = cfg("keyboard_drawer_width", keyboard_drawer_width);
c_kd_h = cfg("keyboard_drawer_height", keyboard_drawer_height);
c_kd_z = cfg("keyboard_drawer_bottom_z", keyboard_drawer_bottom_z);
c_kd_d = cfg("keyboard_drawer_depth", keyboard_drawer_depth);

// ---------- Width ----------
function auto_cab_width() =
    c_is_vpin ? max(700, SW + 2 * cfg("vpin_side_screen_margin", vpin_side_screen_margin) + 2 * T)
              : max(c_players == 2 ? 700 : 560, SW + 2 * c_margin_side + 2 * T);
c_W = let(w = cfg("cabinet_width", cabinet_width)) w > 0 ? w : auto_cab_width();
IW = c_W - 2 * T;

// ---------- Arcade side-view key points ----------
c_F  = [-c_O, c_C];                                            // control panel front top corner
c_R  = c_F + c_cpd * [cos(c_cpa), sin(c_cpa)];                 // control panel rear top corner
c_S0 = c_R + [c_scr_clearance, c_scr_gap];                     // screen panel lower outer corner
c_S1 = c_S0 + c_scr_len * [sin(c_recline), cos(c_recline)];    // screen panel upper outer corner
c_D_arcade = let(d = cfg("cabinet_depth", cabinet_depth)) d > 0 ? d : (c_is_standup ? 650 : 470);
c_head_front = c_marquee_on ? max(10, c_S1[0] - c_mq_proj) : max(10, c_S1[0] - top_forward_projection);
c_H_user = cfg("cabinet_height", cabinet_height);
c_H_arcade = c_H_user > 0 ? c_H_user : c_S1[1] + c_neck_rise_user + c_mq_h;
c_mb = c_H_arcade - c_mq_h;                                     // marquee bottom (= top when no marquee)
c_neck_rise = c_mb - c_S1[1];
c_K  = [-c_O, c_C - c_fas_h];                                   // fascia bottom corner
c_FT = c_kick_drop > 0 ? [0, c_K[1] - c_kick_drop] : [0, c_K[1]]; // front panel top corner
c_has_kick = c_kick_drop > 0;

// ---------- Pinball side-view key points ----------
c_vpin_rise = c_vpin_RH - c_vpin_FH;
function vpin_auto_depth() = c_vpin_step + sqrt(max(1, pow(c_scr_len + c_vpin_apron, 2) - pow(c_vpin_rise, 2)));
c_D_vpin = let(d = cfg("cabinet_depth", cabinet_depth)) d > 0 ? d : vpin_auto_depth();
c_vpin_run = c_D_vpin - c_vpin_step;
c_vpin_slope = atan2(c_vpin_rise, c_vpin_run);
c_vpin_slope_len = sqrt(c_vpin_run * c_vpin_run + c_vpin_rise * c_vpin_rise);
c_vpin_pf_len = c_vpin_slope_len - c_vpin_apron;
c_vpin_B3 = [c_D_vpin - c_vpin_step, c_vpin_RH];
c_vpin_dir = [-cos(c_vpin_slope), -sin(c_vpin_slope)];
c_vpin_Pf = c_vpin_B3 + c_vpin_pf_len * c_vpin_dir;
c_vpin_A  = [0, c_vpin_FH];
function vpin_top_at(y) = c_vpin_FH + c_vpin_rise * min(1, max(0, y / c_vpin_run));

c_D = c_is_vpin ? c_D_vpin : c_D_arcade;
c_H = c_is_vpin ? c_vpin_RH : c_H_arcade;

// ---------- Faces ----------
// [name, P0, P1, has_panel, reversed, own_start, own_end, lip, extra_outer]
//   reversed: the panel's local y runs P1 -> P0 (used for parts whose natural
//             orientation is bottom-to-top or front-to-rear)
//   own_*:    this panel reaches the corner; the neighbour is trimmed
//   lip:      panel outer face sits this far inside the profile line
//   extra:    non-wood material between the profile line and the panel (plexi)
function arcade_faces() = concat(
    [["floor", [0, 0], [c_D, 0], false, false, false, false, 0, 0],
     ["rear", [c_D, 0], [c_D, c_H], true, true, false, false, c_inset, 0],
     ["top_panel", [c_D, c_H], [c_head_front, c_H], true, false, true, !c_marquee_on, c_inset, 0]],
    c_marquee_on ? [["marquee_frame", [c_head_front, c_H], [c_head_front, c_mb], true, true, true, true, c_inset, 0]] : [],
    [["upper_bezel", [c_head_front, c_mb], c_S1, true, true, false, false, c_inset, 0],
     ["screen_panel", c_S1, c_S0, true, true, true, true, c_inset, 0],
     ["lower_bezel", c_S0, c_R, true, true, false, false, c_inset, 0],
     ["control_panel", c_R, c_F, true, true, true, true, c_inset + PT, PT],
     ["control_fascia", c_F, c_K, true, true, false, true, c_inset, 0]],
    c_has_kick ? [["kick_panel", c_K, c_FT, true, true, false, true, c_inset, 0]] : [],
    [["front_panel", c_FT, [0, 0], true, true, false, false, c_inset, 0]]);

function vpin_faces() = [
    ["floor", [0, 0], [c_D, 0], false, false, false, false, 0, 0],
    ["rear", [c_D, 0], [c_D, c_vpin_RH], true, true, false, false, c_inset, 0],
    ["vpin_rear_deck", [c_D, c_vpin_RH], c_vpin_B3, !c_backbox_on, false, true, false, c_inset, 0],
    ["vpin_playfield", c_vpin_B3, c_vpin_Pf, true, true, true, true, c_inset + PT, PT],
    ["vpin_apron", c_vpin_Pf, c_vpin_A, true, true, false, true, c_inset, 0],
    ["front_panel", c_vpin_A, [0, 0], true, true, false, false, c_inset, 0]];

c_faces = c_is_vpin ? vpin_faces() : arcade_faces();
c_nfaces = len(c_faces);
c_profile = [for (f = c_faces) f[1]];

function f_name(f) = f[0];
function f_p0(f) = f[1];
function f_p1(f) = f[2];
function f_has_panel(f) = f[3];
function f_reversed(f) = f[4];
function f_own_start(f) = f[5];
function f_own_end(f) = f[6];
function f_lip(f) = f[7];
function f_extra(f) = f[8];
function f_vec(f) = f_p1(f) - f_p0(f);
function f_len(f) = norm(f_vec(f));
function f_dir(f) = f_vec(f) / f_len(f);
function f_angle(f) = atan2(f_vec(f)[1], f_vec(f)[0]);
function f_normal(f) = let(d = f_dir(f)) [-d[1], d[0]];   // inward (left of the walking direction)
function face_index(name) = let(h = [for (i = [0:c_nfaces-1]) if (f_name(c_faces[i]) == name) i]) len(h) == 0 ? -1 : h[0];
function face(name) = c_faces[face_index(name)];
function face_exists(name) = face_index(name) >= 0 && f_has_panel(face(name));

// Distance along a panel from a convex corner at which its body clears the
// neighbour's body (butt joint: the neighbour reaches the corner, this panel
// stops at the neighbour's inner face). dir_away points from the corner along
// the panel, n_b is the panel's inward normal, n_a the neighbour's; the
// neighbour's wood occupies [lip_a, lip_a + T] measured along n_a. At a
// concave corner the two bodies diverge, so both panels run to the corner.
function butt_trim(dir_away, n_b, lip_b, n_a, lip_a) =
    let(dot = dir_away * n_a, nn = n_b * n_a)
    dot <= 1e-6 ? 0 :
    max(0, (lip_a + T - lip_b * nn) / dot, (lip_a + T - (lip_b + T) * nn) / dot);

function trim_start(i) =
    let(f = c_faces[i], g = c_faces[(i - 1 + c_nfaces) % c_nfaces])
    (!f_has_panel(g) || f_own_start(f)) ? 0 :
    butt_trim(f_dir(f), f_normal(f), f_lip(f), f_normal(g), f_lip(g));
function trim_end(i) =
    let(f = c_faces[i], g = c_faces[(i + 1) % c_nfaces])
    (!f_has_panel(g) || f_own_end(f)) ? 0 :
    butt_trim(-f_dir(f), f_normal(f), f_lip(f), f_normal(g), f_lip(g));

// ---------- Panel records ----------
// [name, width, length, origin(y,z), angle, joinery, sheet_group]
//   origin: the panel's local (x=0,y=0) corner on its INNER face in side view
//   angle:  direction of local +y in side view; the plate extrudes along the
//           left normal of that direction (toward the profile line)
function panel_rec(name, w, len, o, ang, joinery=true) = [name, w, len, o, ang, joinery];
function p_name(p) = p[0];
function p_w(p) = p[1];
function p_len(p) = p[2];
function p_o(p) = p[3];
function p_ang(p) = p[4];
function p_joinery(p) = p[5];
function p_dir(p) = [cos(p_ang(p)), sin(p_ang(p))];
function p_normal(p) = let(d = p_dir(p)) [-d[1], d[0]];

function face_panel_rec(i) =
    let(f = c_faces[i], ts = trim_start(i), te = trim_end(i), L = f_len(f), d = f_dir(f), n = f_normal(f), a = f_angle(f))
    f_reversed(f)
      ? panel_rec(f_name(f), IW, L - ts - te, f_p1(f) - te * d + (f_lip(f) + T) * n, a + 180)
      : panel_rec(f_name(f), IW, L - ts - te, f_p0(f) + ts * d + f_lip(f) * n, a);

c_face_panels = [for (i = [0:c_nfaces-1]) if (f_has_panel(c_faces[i])) face_panel_rec(i)];

// Internal panels
c_bottom_y0 = c_inset + T;
c_bottom_len = c_D - 2 * (c_inset + T);
c_bottom_rec = panel_rec("bottom_panel", IW, c_bottom_len, [c_bottom_y0, c_lift], 0);
c_mq_shelf_on = c_marquee_on && c_mq_shelf > 0;
c_mq_shelf_len = min(c_mq_shelf, c_D - c_head_front - 2 * (c_inset + T));
c_mq_shelf_rec = panel_rec("marquee_shelf", IW, c_mq_shelf_len, [c_head_front + c_inset + T, c_mb], 0);
c_kd_shelf_rec = panel_rec("keyboard_drawer_shelf", c_kd_w, c_kd_d, [c_inset + T, c_kd_z + c_kd_h - T], 0, false);

function panel_by_name(name) = let(h = [for (p = c_all_panels) if (p_name(p) == name) p]) len(h) == 0 ? undef : h[0];
function panel_exists(name) = !is_undef(panel_by_name(name));

// Screen panel frame: used by the VESA mount and the screen preview.
c_screen_rec_name = c_is_vpin ? "vpin_playfield" : "screen_panel";
c_screen_rec = [for (p = c_face_panels) if (p_name(p) == c_screen_rec_name) p][0];
function screen_rec() = c_screen_rec;
function screen_len() = p_len(screen_rec());
// Position of the screen opening along the screen panel so that the visible
// area stays centred on the untrimmed face (margins equal top and bottom).
function screen_open_y0() = let(f = face(c_screen_rec_name), i = face_index(c_screen_rec_name))
    (f_len(f) - c_scr_open_h) / 2 - trim_end(i);   // reversed panel: local y=0 is at P1 side, trimmed by trim_end

// ---------- VESA ----------
function vesa_adjustable() = vesa_mount_style == "adjustable";
function vesa_fixed() = vesa_mount_style == "fixed";
function vesa_mount_panel_h() = vesa_panel_height > 0 ? vesa_panel_height : max(vesa_pattern_y + 2 * vesa_panel_edge_margin, 160);
function vesa_mount_panel_w() = vesa_adjustable() ? IW - 2 * T : IW;
function vesa_mount_local_y0() = screen_open_y0() + (c_scr_open_h - vesa_mount_panel_h()) / 2 + vesa_center_y_offset;
function vesa_mount_local_z0() = -(vesa_panel_setback + T);
function vesa_mount_local_z0_at(s) = -(s + T);
function vesa_adjust_travel() = vesa_adjust_max_setback - vesa_adjust_min_setback;
function vesa_adjust_slot_length() = vesa_adjust_travel() + vesa_adjust_slot_width;
function vesa_adjust_rail_depth() = vesa_adjust_slot_length() + 2 * vesa_adjust_rail_end_margin;
function vesa_adjust_rail_h() = min(vesa_mount_panel_h(), vesa_adjust_rail_height);
function vesa_adjust_rail_y0() = vesa_mount_local_y0() + (vesa_mount_panel_h() - vesa_adjust_rail_h()) / 2;
function vesa_adjust_carrier_center_z() = -(vesa_panel_setback + T / 2);
function vesa_adjust_carrier_x_in_rail() = vesa_adjust_rail_end_margin + vesa_adjust_slot_width / 2 + vesa_adjust_travel();
function vesa_adjust_rail_local_z0() = vesa_adjust_carrier_center_z() - vesa_adjust_carrier_x_in_rail();
function vesa_adjust_fixed_bolt_local_z() = -(vesa_adjust_max_setback + T / 2);
function vesa_adjust_bolt_y_local(i) = vesa_adjust_rail_h() / 2 + (i == 0 ? -1 : 1) * vesa_adjust_bolt_spacing_y / 2;
function vesa_adjust_tab_y_local(i) = vesa_adjust_rail_h() / 2 + (i == 0 ? -1 : 1) * vesa_adjust_carrier_tab_spacing_y / 2;
function vesa_adjust_tab_y_in_carrier(i) = (vesa_adjust_rail_y0() - vesa_mount_local_y0()) + vesa_adjust_tab_y_local(i);
// Screen-panel local (u along panel, z normal, +z toward the player) -> side view
function screen_local_to_side(u, z) = let(s = screen_rec()) p_o(s) + u * p_dir(s) + z * p_normal(s);
c_vesa_fixed_rec = vesa_mount_panel_enabled && vesa_fixed()
    ? panel_rec("vesa_mount_panel", IW, vesa_mount_panel_h(), screen_local_to_side(vesa_mount_local_y0(), vesa_mount_local_z0()), p_ang(screen_rec()), vesa_panel_use_joinery)
    : undef;

c_all_panels = concat(
    c_face_panels,
    [c_bottom_rec],
    c_mq_shelf_on ? [c_mq_shelf_rec] : [],
    c_kd_on ? [c_kd_shelf_rec] : [],
    is_undef(c_vesa_fixed_rec) ? [] : [c_vesa_fixed_rec]);

// Rear service door. Bartop and pinball rear panels are short, so the door is
// pulled down to 60 mm and shrunk to fit the panel instead of failing.
c_rsd_on = cfg("rear_service_door_enabled", rear_service_door_enabled);
c_rsd_w = min(cfg("rear_service_door_width", rear_service_door_width), IW - 10);
c_rsd_z = let(z = cfg("rear_service_door_bottom_z", rear_service_door_bottom_z)) c_is_standup ? z : min(z, 60);
c_rsd_h = let(h = cfg("rear_service_door_height", rear_service_door_height)) c_is_standup ? h : min(h, rear_panel_len() - c_rsd_z - 30);

// ---------- Backbox ----------
c_bb_w = let(w = cfg("vpin_backbox_width", vpin_backbox_width)) w > 0 ? w : c_W;
c_bb_h = cfg("vpin_backbox_height", vpin_backbox_height);
c_bb_d = max(cfg("vpin_backbox_depth", vpin_backbox_depth), 2 * T + 20);
c_bb_iw = c_bb_w - 2 * T;
c_bb_x0 = (c_W - c_bb_w) / 2;
c_bb_y0 = c_D - c_bb_d;
c_bb_z0 = c_vpin_RH;
c_bb_disp_w = cfg("vpin_backbox_display_width", vpin_backbox_display_width);
c_bb_disp_h = cfg("vpin_backbox_display_height", vpin_backbox_display_height);
function bb_display_y0() = c_bb_h - c_bb_disp_h - 28;
function bb_lower_center_y() = max(55, bb_display_y0() / 2);

// ---------- Checks ----------
function front_panel_len() = p_len(panel_by_name("front_panel"));
function rear_panel_len() = p_len(panel_by_name("rear"));
function inside_corner_r() = max(screen_corner_radius, c_tool_r);
c_tab_through = panel_joinery == "tab_slot" && joinery_tab_depth >= T - 1e-6;
c_tab_blind = panel_joinery == "tab_slot" && !c_tab_through;
function required_inset() = panel_joinery == "tab_slot" ? joinery_slot_clearance / 2 + (joinery_dogbone_relief ? c_tool_r : 0) + 2 : 0;

assert(c_players == 1 || c_players == 2, "players must be 1 or 2");
assert(c_buttons >= 4 && c_buttons <= 8, "buttons_per_player must be 4..8");
assert(T > 0 && PT > 0, "Material thicknesses must be positive.");
assert(IW > c_scr_open_w + 10, str("Cabinet is too narrow for the screen opening: inner width ", IW, " mm, opening ", c_scr_open_w, " mm."));
assert(c_inset >= 0, "panel_inset must be >= 0");
assert(panel_joinery == "none" || panel_joinery == "screw" || panel_joinery == "tab_slot", "panel_joinery must be none, screw or tab_slot.");
assert(panel_joinery != "tab_slot" || c_inset >= required_inset(), str("tab_slot joinery needs panel_inset >= ", required_inset(), " mm so the slots stay inside the side panel."));
assert(panel_joinery != "tab_slot" || (joinery_tab_depth > 0 && joinery_tab_depth <= T + 1e-6), "joinery_tab_depth must be > 0 and <= material_thickness.");
assert(joinery_count >= 1 && joinery_count <= 5, "joinery_count must be 1..5");
assert(c_recline >= 0 && c_recline < 35, "screen_recline_angle must be 0..34 degrees.");
assert(c_scr_clearance >= 0 && c_scr_gap >= 0, "control_to_screen_clearance and screen_gap_above_control must be >= 0.");
assert(!c_is_arcade || c_FT[1] > 60, str("Front panel would be only ", c_FT[1], " mm tall: raise the control height or reduce control_fascia_height / kick_drop."));
assert(!c_is_arcade || c_S1[0] < c_D - c_inset - T - 20, "Screen recline/depth pushes the screen panel into the rear panel. Increase cabinet_depth or reduce screen_recline_angle.");
assert(!c_is_arcade || c_neck_rise >= 20, str("Upper bezel rise is ", c_neck_rise, " mm; the cabinet height is too small for the screen and marquee. Increase cabinet_height (or set it to 0) or reduce the marquee height."));
assert(!c_is_arcade || c_head_front > c_R[0] - 50, "Marquee projection places the head in front of the control panel rear edge; reduce marquee_forward_projection.");
assert(!c_is_arcade || c_head_front < c_D - 2 * T - 40, "Head front is too close to the rear of the cabinet.");
assert(!c_is_vpin || c_vpin_run > 100, "vpin_rear_step leaves no room for the playfield slope; reduce it or increase cabinet_depth.");
assert(!c_is_vpin || c_vpin_pf_len >= c_scr_len - 1e-6, str("Pinball playfield is ", c_vpin_pf_len, " mm long but the screen panel needs ", c_scr_len, " mm. Set cabinet_depth = 0 for automatic sizing."));
assert(!c_is_vpin || c_vpin_rise >= 0, "Pinball rear body height must be >= front body height.");
assert(!c_backbox_on || c_bb_w <= c_W + 0.01, "Backbox width cannot exceed the cabinet width.");
assert(!c_backbox_on || c_bb_disp_w + 20 <= c_bb_iw, "Backbox display opening is too wide.");
assert(!c_backbox_on || c_bb_disp_h + 60 <= c_bb_h, "Backbox is too short for the display opening and the speaker/DMD zone.");
assert(!c_coin_door || coin_door_width + 10 <= IW, "Coin door is too wide for the front panel.");
assert(!c_coin_door || c_coin_bottom + coin_door_height + 5 <= front_panel_len(), "Coin door does not fit on the front panel.");
assert(!c_kd_on || c_kd_w + 10 <= IW, "Keyboard drawer is too wide for the front panel.");
assert(!c_kd_on || c_kd_z + c_kd_h + 5 <= front_panel_len(), "Keyboard drawer opening does not fit on the front panel.");
assert(!c_rsd_on || c_rsd_w + 10 <= IW, "Rear service door is too wide for the rear panel.");
assert(!c_rsd_on || c_rsd_z + c_rsd_h + 5 <= rear_panel_len(), "Rear service door does not fit on the rear panel.");
assert(vesa_mount_style == "fixed" || vesa_mount_style == "adjustable", "vesa_mount_style must be fixed or adjustable.");
assert(!vesa_mount_panel_enabled || vesa_mount_panel_h() >= vesa_pattern_y + 2 * vesa_panel_edge_margin, "VESA panel is too short for the Y pattern plus margins.");
assert(!vesa_mount_panel_enabled || abs(vesa_center_x_offset) + vesa_pattern_x / 2 + vesa_panel_edge_margin <= vesa_mount_panel_w() / 2, "VESA X pattern does not fit the carrier width.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || IW > 4 * T, "Cabinet is too narrow for the adjustable VESA rails.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || (vesa_adjust_min_setback >= 0 && vesa_adjust_max_setback > vesa_adjust_min_setback), "Adjustable VESA min/max setback range is invalid.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || (vesa_panel_setback >= vesa_adjust_min_setback && vesa_panel_setback <= vesa_adjust_max_setback), "vesa_panel_setback must lie inside the adjustable range.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_slot_width >= vesa_adjust_bolt_hole_diameter, "VESA rail slot width must be at least the bolt diameter.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_min_setback + T / 2 > vesa_adjust_rail_end_margin + vesa_adjust_slot_width / 2, "Adjustable VESA rail would reach the bezel plane at minimum setback.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_rail_h() >= vesa_adjust_bolt_spacing_y + vesa_adjust_slot_width + 12, "VESA rail is too short for the two adjustment slots.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_carrier_tab_spacing_y >= vesa_adjust_carrier_tab_width + 4, "VESA carrier tabs overlap.");
assert(!vesa_mount_panel_enabled || !vesa_adjustable() || vesa_adjust_carrier_tab_spacing_y + vesa_adjust_carrier_tab_width <= vesa_adjust_bolt_spacing_y - vesa_adjust_slot_width - 4, "VESA carrier mortises overlap the adjustment slots.");
assert(!vesa_mount_panel_enabled || vesa_mount_panel_h() <= screen_len(), "VESA carrier is taller than the screen panel.");
