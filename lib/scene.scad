// Machine-readable scene description for external viewers (the web app).
//
// output_mode = "scene" echoes one JSON object per line, each prefixed by a
// tag:
//   INFO:   overall dimensions, style, stock
//   BOM:    one row per part type (name, material, w, len, qty)
//   LAYOUT: one row per part instance in the "all_sheet" drawing: the rect
//           it occupies and the sheet offset of the part's local origin
//   SCENE:  one row per 3D element: the 2D drawing to extrude ("part"), its
//           thickness and a 4x4 placement matrix (row major), or a box
//   CHECK:  derived values a front end may want to show
// output_mode = "all_sheet" draws every part (wood, plexi, pockets) in the
// same row layout so a single SVG export carries every outline.

function m_tr(v) = [[1, 0, 0, v[0]], [0, 1, 0, v[1]], [0, 0, 1, v[2]], [0, 0, 0, 1]];
function m_rx(a) = [[1, 0, 0, 0], [0, cos(a), -sin(a), 0], [0, sin(a), cos(a), 0], [0, 0, 0, 1]];
M_PROFILE_X = [[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]];   // 2D (x,y) -> (Y,Z), extrude -> +X
M_PANEL_Y   = [[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]];   // 2D (x,y) -> (X,Z), extrude -> +Y
M_RAIL_X    = [[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 0, 1]];
function m_place(p) = m_tr([T, p_o(p)[0], p_o(p)[1]]) * m_rx(p_ang(p));
function m_lift() = m_tr([0, 0, c_vpin_Z0]);

function js(s) = str("\"", s, "\"");
module scene_part(part, kind, t, M) echo(str("SCENE:{\"part\":", js(part), ",\"kind\":", js(kind), ",\"t\":", t, ",\"m\":", M, "}"));
module scene_box(kind, size, M) echo(str("SCENE:{\"box\":", size, ",\"kind\":", js(kind), ",\"m\":", M, "}"));

function all_sheet_parts() = all_parts();
function layout_origin_offset(name) =
    (name == "left_side" || name == "right_side" || name == "left_side_pockets" || name == "right_side_pockets")
      ? [name == "right_side" || name == "right_side_pockets" ? c_D : (c_is_arcade ? c_O : 0), 0]
      : [tab_offset(name), 0];

module all_sheet_2d() { sheet_layout(all_sheet_parts()); }

module print_scene() {
    echo(str("INFO:{\"style\":", js(c_style), ",\"preset\":", js(design_preset), ",\"W\":", c_W, ",\"D\":", c_D + (c_is_arcade ? c_O : 0),
             ",\"H\":", c_H + c_vpin_Z0 + (c_backbox_on ? c_bb_h : 0), ",\"body_D\":", c_D, ",\"body_H\":", c_H, ",\"IW\":", IW, ",\"T\":", T, ",\"PT\":", PT,
             ",\"screen_w\":", SW, ",\"screen_h\":", SH, ",\"control_height\":", c_C + c_vpin_Z0, ",\"lift\":", c_vpin_Z0,
             ",\"backglass_w\":", c_backbox_on ? c_bg_w : 0, ",\"backglass_h\":", c_backbox_on ? c_bg_h : 0, ",\"backbox_h\":", c_backbox_on ? c_bb_h : 0, "}"));
    for (p = all_parts())
        echo(str("BOM:{\"part\":", js(p[0]), ",\"material\":", js(p[1]), ",\"w\":", round(p[2] * 10) / 10, ",\"len\":", round(p[3] * 10) / 10, ",\"qty\":", p[4], "}"));
    parts = with_qty(all_sheet_parts());
    placed = row_assign(parts);
    for (i = [0:len(placed)-1]) {
        e = placed[i]; p = parts[i]; off = layout_origin_offset(e[0]);
        echo(str("LAYOUT:{\"part\":", js(e[0]), ",\"material\":", js(p[1]), ",\"x\":", e[1], ",\"y\":", e[2], ",\"w\":", p[2], ",\"h\":", p[3],
                 ",\"ox\":", e[1] + off[0], ",\"oy\":", e[2] + off[1], "}"));
    }
    // ---- 3D elements (mirror of lib/assembly.scad) ----
    L = m_lift();
    scene_part("left_side", "side", T, L * M_PROFILE_X);
    scene_part("left_side", "side", T, L * m_tr([c_W - T, 0, 0]) * M_PROFILE_X);
    for (p = c_all_panels) {
        n = p_name(p);
        kind = (n == "bottom_panel" || n == "marquee_shelf" || n == "keyboard_drawer_shelf" || n == "vesa_mount_panel") ? "inner" : "panel";
        if (n == "keyboard_drawer_shelf") scene_part(n, kind, T, L * m_tr([T + (IW - c_kd_w) / 2, p_o(p)[0], p_o(p)[1]]));
        else scene_part(n == "rear" ? "rear_panel" : n, kind, T, L * m_place(p));
    }
    if (panel_exists("control_panel")) scene_part("control_plexi", "plexi", PT, L * m_place(part_rec("control_panel")) * m_tr([0, 0, T]));
    scene_part("screen_plexi", "plexi", PT, L * m_place(screen_rec()) * m_tr([0, 0, T]));
    if (c_marquee_on) scene_part("marquee_plexi", "plexi", PT, L * m_place(part_rec("marquee_frame")) * m_tr([0, 0, T]));
    scene_box("screen", [SW, SH, 2], L * m_place(screen_rec()) * m_tr([(IW - SW) / 2, screen_open_y0() + screen_cutout_clearance, -2.5]));
    if (vesa_mount_panel_enabled && vesa_adjustable()) {
        S = L * m_place(screen_rec());
        scene_part("vesa_mount_panel", "inner", T, S * m_tr([T, vesa_mount_local_y0(), vesa_mount_local_z0()]));
        scene_part("vesa_adjust_rail", "inner", T, S * m_tr([0, vesa_adjust_rail_y0(), vesa_adjust_rail_local_z0()]) * M_RAIL_X);
        scene_part("vesa_adjust_rail", "inner", T, S * m_tr([IW - T, vesa_adjust_rail_y0(), vesa_adjust_rail_local_z0()]) * M_RAIL_X);
    }
    if (c_is_arcade) {
        fp = part_rec("front_panel");
        if (c_coin_door) scene_part("coin_door", "door", T, L * m_tr([T + (IW - coin_door_width) / 2, p_o(fp)[0] - T, c_coin_bottom]) * M_PANEL_Y);
        if (c_kd_on) scene_part("keyboard_drawer_front", "door", T, L * m_tr([T + (IW - c_kd_w) / 2, p_o(fp)[0] - T, c_kd_z]) * M_PANEL_Y);
    }
    if (c_rsd_on) { scene_part("rear_service_door", "door", T, L * m_tr([T + (IW - c_rsd_w) / 2, rear_door_y0(), c_rsd_z]) * M_PANEL_Y); }
    if (c_backbox_on) {
        X = c_bb_x0; Y = c_bb_y0; Z = c_bb_z0;
        scene_part("vpin_backbox_side", "side", T, L * m_tr([X, Y, Z]) * M_PROFILE_X);
        scene_part("vpin_backbox_side", "side", T, L * m_tr([X + c_bb_w - T, Y, Z]) * M_PROFILE_X);
        scene_part("vpin_backbox_front", "panel", T, L * m_tr([X + T, Y, Z]) * M_PANEL_Y);
        scene_part("vpin_backbox_rear", "panel", T, L * m_tr([X + T, Y + c_bb_d - T, Z]) * M_PANEL_Y);
        scene_part("vpin_backbox_bottom", "inner", T, L * m_tr([X + T, Y + T, Z]));
        scene_part("vpin_backbox_top", "panel", T, L * m_tr([X + T, Y, Z + c_bb_h - T]));
        scene_part("vpin_backbox_plexi", "plexi", PT, L * m_tr([X + T, Y - PT - 0.5, Z]) * M_PANEL_Y);
        scene_box("screen", [c_bg_w, 2, c_bg_h], L * m_tr([X + T + (c_bb_iw - c_bg_w) / 2, Y + T + 0.5, Z + bb_display_y0() + screen_cutout_clearance]));
    }
    if (c_full_vpin) { leg = vpin_leg_size;
        for (x = [T + 25, c_W - T - 25 - leg]) for (y = [55, c_D - 95]) scene_box("leg", [leg, leg, c_vpin_Z0], m_tr([x, y, 0]));
    }
}
