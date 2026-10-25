// 2D parts. Each cross panel is drawn with x across the cabinet (0..width)
// and y along the panel in its natural orientation (front->rear for the
// control panel, bottom->top for vertical and sloped panels).

function part_rec(name) = panel_by_name(name);
function part_len(name) = p_len(part_rec(name));
function part_w(name) = p_w(part_rec(name));
function aux_on_control() = c_aux_loc == "control" || c_aux_loc == "both";
function aux_on_fascia() = c_aux_loc == "fascia" || c_aux_loc == "both";
function effective_player_spacing(w) = min(cfg("player_spacing", player_spacing), w * 0.48);
function player_center_x(i, w) = c_players == 1 ? w / 2 : w / 2 + (i == 0 ? -1 : 1) * effective_player_spacing(w) / 2;
function controls_y(len) = min(cfg("controls_from_front_edge", controls_from_front_edge), len - 40);

// ---------- Control cutouts ----------
module action_button_holes(w, len, extra=0) {
    top_n = ceil(c_buttons / 2); bottom_n = floor(c_buttons / 2);
    cy = controls_y(len);
    pitch = button_pitch; rp = button_row_pitch; R = button_arc_radius;
    d = action_button_hole() + 2 * extra;
    for (p = [0:c_players-1]) {
        cx = player_center_x(p, w) + joystick_to_button_cluster / 2;
        if (c_button_layout == "arc") {
            // Rows follow concentric arcs centred below the cluster, so the
            // outer buttons drop toward the player (Vewlix / Candy style).
            for (i = [0:top_n-1]) {
                a = (i - (top_n - 1) / 2) * pitch / R * 180 / PI;
                translate([cx + R * sin(a), cy + rp / 2 - R * (1 - cos(a))]) circle(d=d);
            }
            for (i = [0:bottom_n-1]) {
                a = (i - (bottom_n - 1) / 2) * pitch / (R - rp) * 180 / PI;
                translate([cx + (R - rp) * sin(a), cy - rp / 2 - (R - rp) * (1 - cos(a))]) circle(d=d);
            }
        } else {
            x0 = cx - (top_n - 1) * pitch / 2;
            for (i = [0:top_n-1]) translate([x0 + i * pitch, cy + rp / 2]) circle(d=d);
            for (i = [0:bottom_n-1]) translate([x0 + pitch / 2 + i * pitch, cy - rp / 2]) circle(d=d);
        }
    }
}

module joystick_holes(w, len, extra=0, include_mounts=true) {
    if (c_joysticks) {
        cy = controls_y(len);
        for (p = [0:c_players-1]) {
            jx = player_center_x(p, w) - joystick_to_button_cluster / 2;
            translate([jx, cy]) circle(d=js_shaft_hole() + 2 * extra);
            if (include_mounts && joystick_mount_holes_enabled)
                for (dx = [-1, 1]) for (dy = [-1, 1])
                    translate([jx + dx * js_mount_dx() / 2, cy + dy * js_mount_dy() / 2]) circle(d=js_mount_hole() + 2 * extra, $fn=24);
        }
    }
}

module trackball_holes(w, len, extra=0, include_mounts=true) {
    if (c_trackball) {
        tx = w / 2 + trackball_x_offset; ty = len * trackball_y_fraction;
        translate([tx, ty]) circle(d=tb_cutout() + 2 * extra, $fn=96);
        if (include_mounts && trackball_mount_holes_enabled)
            for (dx = [-1, 1]) for (dy = [-1, 1])
                translate([tx + dx * tb_mount_spacing() / 2, ty + dy * tb_mount_spacing() / 2]) circle(d=tb_mount_hole() + 2 * extra, $fn=24);
    }
}

module aux_row_holes(w, y, extra=0) {
    if (c_aux_count > 0) {
        x0 = w / 2 - (c_aux_count - 1) * aux_button_spacing / 2;
        for (i = [0:c_aux_count-1]) translate([x0 + i * aux_button_spacing, y]) circle(d=aux_button_diameter + 2 * extra);
    }
}

module control_cutouts(w, len, extra=0, include_mounts=true) {
    action_button_holes(w, len, extra);
    joystick_holes(w, len, extra, include_mounts);
    trackball_holes(w, len, extra, include_mounts);
    if (aux_on_control()) aux_row_holes(w, len - aux_rear_margin, extra);
}

// ---------- Cross panels ----------
module blank_part(name) { p = part_rec(name); panel_blank(p_w(p), p_len(p), panel_tabs_eligible(p)); }

module control_panel_2d(plexi=false) {
    p = part_rec("control_panel"); w = p_w(p); len = p_len(p);
    difference() {
        if (plexi) translate([plexi_edge_inset, plexi_edge_inset]) square([w - 2 * plexi_edge_inset, len - 2 * plexi_edge_inset]);
        else panel_blank(w, len, panel_tabs_eligible(p));
        control_cutouts(w, len, plexi ? plexi_hole_clearance : 0, true);
    }
}

module control_fascia_2d() {
    p = part_rec("control_fascia"); w = p_w(p); len = p_len(p);
    difference() {
        panel_blank(w, len, panel_tabs_eligible(p));
        if (aux_on_fascia()) aux_row_holes(w, len * 0.55);
    }
}

module screen_like_panel_2d(name, plexi=false) {
    p = part_rec(name); w = p_w(p); len = p_len(p);
    difference() {
        if (plexi) translate([plexi_edge_inset, plexi_edge_inset]) square([w - 2 * plexi_edge_inset, len - 2 * plexi_edge_inset]);
        else panel_blank(w, len, panel_tabs_eligible(p));
        if (!plexi || monitor_plexi_window)
            translate([w / 2, screen_open_y0() + c_scr_open_h / 2]) rounded_rect_2d(c_scr_open_w, c_scr_open_h, inside_corner_r(), true);
    }
}

module speaker_row(w, y) {
    n = speaker_count;
    if (n > 0) {
        sp = min(speaker_spacing, n <= 1 ? 0 : (w - speaker_cutout_diameter - 30) / (n - 1));
        x0 = n == 1 ? w / 2 : w / 2 - (n - 1) * sp / 2;
        for (i = [0:n-1]) translate([x0 + i * sp, y]) circle(d=speaker_cutout_diameter, $fn=72);
    }
}

module upper_bezel_2d() {
    p = part_rec("upper_bezel"); w = p_w(p); len = p_len(p);
    difference() {
        panel_blank(w, len, panel_tabs_eligible(p));
        if (len > speaker_cutout_diameter + 20) speaker_row(w, len / 2);
    }
}

module marquee_frame_2d() {
    p = part_rec("marquee_frame"); w = p_w(p); len = p_len(p);
    b = max(marquee_frame_border, T + 4);
    difference() {
        panel_blank(w, len, panel_tabs_eligible(p));
        translate([b, b]) rounded_rect_2d(w - 2 * b, len - 2 * b, inside_corner_r());
    }
}

module marquee_plexi_2d() {
    p = part_rec("marquee_frame");
    translate([plexi_edge_inset, plexi_edge_inset]) square([p_w(p) - 2 * plexi_edge_inset, p_len(p) - 2 * plexi_edge_inset]);
}

module front_panel_2d() {
    p = part_rec("front_panel"); w = p_w(p); len = p_len(p);
    difference() {
        panel_blank(w, len, panel_tabs_eligible(p));
        if (c_is_arcade && aux_on_fascia() && !face_exists("control_fascia")) aux_row_holes(w, len * 0.6);
        if (c_coin_door)
            translate([(w - coin_door_width) / 2 - coin_door_clearance / 2, c_coin_bottom - coin_door_clearance / 2])
                square([coin_door_width + coin_door_clearance, coin_door_height + coin_door_clearance]);
        if (c_kd_on)
            translate([(w - c_kd_w) / 2 - keyboard_drawer_clearance / 2, c_kd_z - keyboard_drawer_clearance / 2])
                square([c_kd_w + keyboard_drawer_clearance, c_kd_h + keyboard_drawer_clearance]);
        if (c_is_vpin) {
            translate([w * 0.82, len * 0.6]) circle(d=pinball_launch_button_diameter);
            translate([w * 0.18, len * 0.6]) circle(d=pinball_start_button_diameter);
        }
    }
}

module rear_panel_2d() {
    p = part_rec("rear"); w = p_w(p); len = p_len(p);
    difference() {
        panel_blank(w, len, panel_tabs_eligible(p));
        if (c_rsd_on)
            translate([(w - c_rsd_w) / 2 - rear_service_door_clearance / 2, c_rsd_z - rear_service_door_clearance / 2])
                square([c_rsd_w + rear_service_door_clearance, c_rsd_h + rear_service_door_clearance]);
        if (rear_vent_rows > 0) {
            vy0 = (c_rsd_on ? c_rsd_z + c_rsd_h : len * 0.6) + 40;
            n = floor((w * 0.6) / rear_vent_hole_pitch);
            for (r = [0:rear_vent_rows-1]) for (i = [0:n-1])
                if (vy0 + r * rear_vent_hole_pitch < len - 30)
                    translate([w / 2 + (i - (n - 1) / 2) * rear_vent_hole_pitch, vy0 + r * rear_vent_hole_pitch]) circle(d=rear_vent_hole_diameter, $fn=24);
        }
        if (rear_cable_hole_diameter > 0)
            translate([w * 0.8, max(rear_cable_hole_diameter, c_lift + T + rear_cable_hole_diameter / 2 + 20)]) circle(d=rear_cable_hole_diameter);
    }
}

module rear_service_door_2d() {
    if (c_rsd_on) {
        w = c_rsd_w; h = c_rsd_h; inset = 32;
        difference() {
            square([w, h]);
            for (x = [inset, w - inset]) for (y = [inset, h - inset]) translate([x, y]) circle(d=rear_service_door_mount_hole_diameter, $fn=24);
            n = rear_service_door_vent_holes; rows = ceil(n / 2);
            if (n > 0) for (i = [0:n-1]) translate([w * (0.35 + 0.30 * (i % 2)), h * (floor(i / 2) + 1) / (rows + 1)]) circle(d=rear_service_door_vent_diameter);
        }
    }
}

module coin_door_2d() {
    if (c_coin_door) {
        w = coin_door_width; h = coin_door_height; n = coin_door_button_count;
        difference() {
            square([w, h]);
            if (n > 0) { sp = min(60, w / (n + 1)); for (i = [0:n-1]) translate([w / 2 + (i - (n - 1) / 2) * sp, h * 0.72]) circle(d=coin_door_button_diameter); }
        }
    }
}

module bottom_panel_2d() {
    p = part_rec("bottom_panel"); w = p_w(p); len = p_len(p);
    difference() {
        panel_blank(w, len, panel_tabs_eligible(p));
        if (leveler_hole_diameter > 0)
            for (x = [leveler_hole_inset, w - leveler_hole_inset]) for (y = [leveler_hole_inset, len - leveler_hole_inset])
                translate([x, y]) circle(d=leveler_hole_diameter, $fn=24);
    }
}

module keyboard_drawer_front_2d() { if (c_kd_on) square([c_kd_w, c_kd_h]); }
module keyboard_drawer_shelf_2d() { if (c_kd_on) square([c_kd_w, c_kd_d]); }

// ---------- VESA ----------
module vesa_mortise_2d(len, wid) { dogbone_slot_2d(len, wid, vesa_adjust_joinery_dogbones); }

module vesa_mount_panel_2d() {
    if (vesa_mount_panel_enabled) {
        w = vesa_mount_panel_w(); h = vesa_mount_panel_h();
        cx = w / 2 + vesa_center_x_offset; cy = h / 2;
        difference() {
            if (vesa_adjustable()) union() {
                square([w, h]);
                for (i = [0:1]) { ty = vesa_adjust_tab_y_in_carrier(i);
                    translate([-T, ty - vesa_adjust_carrier_tab_width / 2]) square([T, vesa_adjust_carrier_tab_width]);
                    translate([w, ty - vesa_adjust_carrier_tab_width / 2]) square([T, vesa_adjust_carrier_tab_width]); }
            } else panel_blank(w, h, vesa_panel_use_joinery);
            for (sx = [-1, 1]) for (sy = [-1, 1]) translate([cx + sx * vesa_pattern_x / 2, cy + sy * vesa_pattern_y / 2]) circle(d=vesa_hole_diameter, $fn=32);
        }
    }
}

module vesa_adjust_rail_2d() {
    if (vesa_mount_panel_enabled && vesa_adjustable()) {
        d = vesa_adjust_rail_depth(); h = vesa_adjust_rail_h();
        difference() {
            square([d, h]);
            for (i = [0:1]) translate([d / 2, vesa_adjust_bolt_y_local(i)]) capsule_slot_2d(vesa_adjust_slot_length(), vesa_adjust_slot_width);
            for (i = [0:1]) translate([vesa_adjust_carrier_x_in_rail(), vesa_adjust_tab_y_local(i)])
                vesa_mortise_2d(T + vesa_adjust_joinery_clearance, vesa_adjust_carrier_tab_width + vesa_adjust_joinery_clearance);
        }
    }
}

// ---------- Pinball ----------
module vpin_apron_2d() {
    p = part_rec("vpin_apron"); w = p_w(p); len = p_len(p); n = vpin_apron_button_count;
    difference() {
        panel_blank(w, len, panel_tabs_eligible(p));
        if (n > 0) for (i = [0:n-1]) translate([w / 2 + (i - (n - 1) / 2) * aux_button_spacing, len / 2]) circle(d=aux_button_diameter);
    }
}

module vpin_backbox_side_2d() { if (c_backbox_on) square([c_bb_d, c_bb_h]); }
module vpin_backbox_front_2d(plexi=false) {
    if (c_backbox_on) {
        w = c_bb_iw; h = c_bb_h; inset = plexi ? plexi_edge_inset : 0;
        difference() {
            translate([inset, inset]) square([w - 2 * inset, h - 2 * inset]);
            if (!plexi || vpin_backbox_plexi_window) {
                translate([w / 2, bb_display_y0() + c_bb_disp_h / 2]) rounded_rect_2d(c_bb_disp_w, c_bb_disp_h, max(vpin_backbox_display_corner_radius, c_tool_r), true);
                if (vpin_backbox_dmd_enabled) translate([w / 2, bb_lower_center_y()]) rounded_rect_2d(vpin_backbox_dmd_width, vpin_backbox_dmd_height, c_tool_r, true);
                n = vpin_backbox_speaker_count;
                if (n > 0) { sp = min(vpin_backbox_speaker_spacing, n <= 1 ? 0 : (w - vpin_backbox_speaker_diameter - 30) / (n - 1));
                    for (i = [0:n-1]) translate([w / 2 + (i - (n - 1) / 2) * sp, bb_lower_center_y()]) circle(d=vpin_backbox_speaker_diameter, $fn=72); }
            }
        }
    }
}
module vpin_backbox_rear_2d() { if (c_backbox_on) square([c_bb_iw, c_bb_h]); }
module vpin_backbox_top_2d() { if (c_backbox_on) square([c_bb_iw, c_bb_d]); }
module vpin_backbox_bottom_2d() { if (c_backbox_on) square([c_bb_iw, c_bb_d - T]); }

// ---------- Side panels ----------
module side_outline_2d() {
    if (c_corner_r > 0) offset(r=c_corner_r, $fn=48) offset(delta=-c_corner_r) polygon(points=c_profile);
    else polygon(points=c_profile);
}

module side_panel_2d() {
    difference() {
        side_outline_2d();
        for (p = c_all_panels) side_joint_features(p, "through");
        if (vesa_mount_panel_enabled && vesa_adjustable() && vesa_adjust_side_holes_enabled)
            for (i = [0:1]) translate(screen_local_to_side(vesa_adjust_rail_y0() + vesa_adjust_bolt_y_local(i), vesa_adjust_fixed_bolt_local_z()))
                circle(d=vesa_adjust_bolt_hole_diameter, $fn=32);
        if (c_is_vpin && pinball_side_buttons)
            translate([pinball_flipper_from_front, vpin_top_at(pinball_flipper_from_front) - pinball_flipper_from_top]) circle(d=pinball_flipper_hole_diameter);
    }
}

// Blind tab pockets only (depth = joinery_tab_depth, assigned in CAM).
module side_pockets_2d() { for (p = c_all_panels) side_joint_features(p, "pocket"); }

// ---------- Dispatcher ----------
module part_2d(name) {
    if (name == "left_side") side_panel_2d();
    else if (name == "right_side") mirror([1, 0]) side_panel_2d();
    else if (name == "left_side_pockets") side_pockets_2d();
    else if (name == "right_side_pockets") mirror([1, 0]) side_pockets_2d();
    else if (name == "control_panel") control_panel_2d(false);
    else if (name == "control_plexi") control_panel_2d(true);
    else if (name == "control_fascia") control_fascia_2d();
    else if (name == "screen_panel") screen_like_panel_2d("screen_panel", false);
    else if (name == "screen_plexi") screen_like_panel_2d(c_screen_rec_name, true);
    else if (name == "vpin_playfield") screen_like_panel_2d("vpin_playfield", false);
    else if (name == "upper_bezel") upper_bezel_2d();
    else if (name == "marquee_frame") marquee_frame_2d();
    else if (name == "marquee_plexi") marquee_plexi_2d();
    else if (name == "front_panel") front_panel_2d();
    else if (name == "rear_panel" || name == "rear") rear_panel_2d();
    else if (name == "rear_service_door") rear_service_door_2d();
    else if (name == "coin_door") coin_door_2d();
    else if (name == "bottom_panel") bottom_panel_2d();
    else if (name == "keyboard_drawer_front") keyboard_drawer_front_2d();
    else if (name == "keyboard_drawer_shelf") keyboard_drawer_shelf_2d();
    else if (name == "vesa_mount_panel") vesa_mount_panel_2d();
    else if (name == "vesa_adjust_rail") vesa_adjust_rail_2d();
    else if (name == "vpin_apron") vpin_apron_2d();
    else if (name == "vpin_backbox_side") vpin_backbox_side_2d();
    else if (name == "vpin_backbox_front") vpin_backbox_front_2d(false);
    else if (name == "vpin_backbox_plexi") vpin_backbox_front_2d(true);
    else if (name == "vpin_backbox_rear") vpin_backbox_rear_2d();
    else if (name == "vpin_backbox_top") vpin_backbox_top_2d();
    else if (name == "vpin_backbox_bottom") vpin_backbox_bottom_2d();
    else if (panel_exists(name)) blank_part(name);     // top, kick, lower bezel, marquee shelf, rear deck ...
    else assert(false, str("Unknown part_name: ", name));
}
