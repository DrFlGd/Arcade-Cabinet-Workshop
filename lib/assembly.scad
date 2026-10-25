// 3D assembly preview built from the panel records.

col_side  = [0.30, 0.30, 0.32];
col_panel = [0.80, 0.64, 0.42];
col_inner = [0.70, 0.56, 0.36];
col_plexi = [0.55, 0.80, 1.0, 0.30];
col_screen = [0.02, 0.02, 0.03];

// 2D side-view drawing (y, z) -> world (Y, Z), extruded along +X.
module extrude_profile_along_x(thickness) {
    multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) linear_extrude(height=thickness) children();
}
// Rail drawing (x = depth along the screen normal, y = along the screen plane) -> local Y/Z, extruded along local X.
module extrude_vesa_rail_along_x(thickness) {
    multmatrix([[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 0, 1]]) linear_extrude(height=thickness) children();
}
// Front/rear-style panel (x across, y up) -> world X/Z, extruded along +Y.
module extrude_panel_along_y(thickness) {
    multmatrix([[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) linear_extrude(height=thickness) children();
}

// Place a cross panel: local origin at its inner-face corner, local y along
// p_ang, plate extruded along the left normal (toward the profile line).
module place_panel(p) {
    translate([T, p_o(p)[0], p_o(p)[1]]) rotate([p_ang(p), 0, 0]) children();
}

module side_panels() {
    color(col_side) {
        extrude_profile_along_x(T) side_panel_2d();
        translate([c_W - T, 0, 0]) extrude_profile_along_x(T) side_panel_2d();
        if (c_tab_blind) {   // show the blind pockets as recesses on the inner faces
            // (visual only; the pockets are differenced from a thin inner layer)
        }
    }
}

module cross_panels() {
    for (p = c_all_panels) {
        n = p_name(p);
        c = (n == "bottom_panel" || n == "marquee_shelf" || n == "keyboard_drawer_shelf" || n == "vesa_mount_panel") ? col_inner : col_panel;
        if (n == "keyboard_drawer_shelf")
            color(c) translate([T + (IW - c_kd_w) / 2, p_o(p)[0], p_o(p)[1]]) linear_extrude(T) part_2d(n);
        else
            color(c) place_panel(p) linear_extrude(T) part_2d(n == "rear" ? "rear_panel" : n);
    }
}

module plexi_and_screen() {
    if (show_plexi_preview) {
        if (panel_exists("control_panel")) color(col_plexi) place_panel(part_rec("control_panel")) translate([0, 0, T]) linear_extrude(PT) control_panel_2d(true);
        color(col_plexi) place_panel(screen_rec()) translate([0, 0, T]) linear_extrude(PT) screen_like_panel_2d(c_screen_rec_name, true);
        if (c_marquee_on) color(col_plexi) place_panel(part_rec("marquee_frame")) translate([0, 0, T]) linear_extrude(PT) marquee_plexi_2d();
    }
    if (show_screen_preview)
        color(col_screen) place_panel(screen_rec()) translate([(IW - SW) / 2, screen_open_y0() + screen_cutout_clearance, T + PT + 0.5]) cube([SW, SH, 2]);
}

module vesa_mount() {
    if (vesa_mount_panel_enabled) place_panel(screen_rec()) {
        if (vesa_adjustable()) {
            color(col_inner) translate([T, vesa_mount_local_y0(), vesa_mount_local_z0()]) linear_extrude(T) vesa_mount_panel_2d();
            color([0.55, 0.42, 0.26]) {
                translate([0, vesa_adjust_rail_y0(), vesa_adjust_rail_local_z0()]) extrude_vesa_rail_along_x(T) vesa_adjust_rail_2d();
                translate([IW - T, vesa_adjust_rail_y0(), vesa_adjust_rail_local_z0()]) extrude_vesa_rail_along_x(T) vesa_adjust_rail_2d();
            }
            if (show_vesa_adjustment_envelope) {
                color([0.25, 0.75, 1.0, 0.15]) translate([T, vesa_mount_local_y0(), vesa_mount_local_z0_at(vesa_adjust_min_setback)]) linear_extrude(T) vesa_mount_panel_2d();
                color([1.0, 0.55, 0.20, 0.15]) translate([T, vesa_mount_local_y0(), vesa_mount_local_z0_at(vesa_adjust_max_setback)]) linear_extrude(T) vesa_mount_panel_2d();
            }
        }
        // fixed carrier is a regular panel record and is drawn by cross_panels()
    }
}

module doors_and_drawers() {
    fp = part_rec("front_panel");
    if (c_coin_door) color([0.35, 0.35, 0.38]) translate([T + (IW - coin_door_width) / 2, p_o(fp)[0] - T, c_coin_bottom]) extrude_panel_along_y(T) coin_door_2d();
    if (c_kd_on) color([0.45, 0.40, 0.33]) translate([T + (IW - c_kd_w) / 2, p_o(fp)[0] - T, c_kd_z]) extrude_panel_along_y(T) keyboard_drawer_front_2d();
    if (c_rsd_on) { rp = part_rec("rear"); color([0.45, 0.40, 0.33]) translate([T + (IW - c_rsd_w) / 2, p_o(rp)[0], c_rsd_z]) extrude_panel_along_y(T) rear_service_door_2d(); }
}

module backbox() {
    if (c_backbox_on) {
        X = c_bb_x0; Y = c_bb_y0; Z = c_bb_z0;
        color(col_side) { translate([X, Y, Z]) extrude_profile_along_x(T) vpin_backbox_side_2d(); translate([X + c_bb_w - T, Y, Z]) extrude_profile_along_x(T) vpin_backbox_side_2d(); }
        color(col_panel) translate([X + T, Y, Z]) extrude_panel_along_y(T) vpin_backbox_front_2d(false);
        color(col_panel) translate([X + T, Y + c_bb_d - T, Z]) extrude_panel_along_y(T) vpin_backbox_rear_2d();
        color(col_inner) translate([X + T, Y + T, Z]) linear_extrude(T) vpin_backbox_bottom_2d();
        color(col_panel) translate([X + T, Y, Z + c_bb_h - T]) linear_extrude(T) vpin_backbox_top_2d();
        if (show_plexi_preview) color(col_plexi) translate([X + T, Y - PT - 0.5, Z]) extrude_panel_along_y(PT) vpin_backbox_front_2d(true);
    }
}

module body() {
    side_panels();
    cross_panels();
    plexi_and_screen();
    vesa_mount();
    doors_and_drawers();
    backbox();
}

module legs() {
    if (c_full_vpin) { leg = vpin_leg_size;
        for (x = [T + 25, c_W - T - 25 - leg]) for (y = [55, c_D - 95]) color([0.25, 0.25, 0.25]) translate([x, y, 0]) cube([leg, leg, c_vpin_Z0]);
    }
}

module assembly() {
    if (show_cutaway)
        difference() { union() { translate([0, 0, c_vpin_Z0]) body(); legs(); }
            translate([-1, -2000, -1]) cube([c_W / 2 + 1, 6000, 6000]); }
    else { translate([0, 0, c_vpin_Z0]) body(); legs(); }
}
