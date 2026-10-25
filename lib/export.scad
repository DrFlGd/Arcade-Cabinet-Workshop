// Part export, sheet overviews and bill of materials.

// Parts available for the current configuration: [name, material, w, h, qty]
function cross_panel_parts() = [for (p = c_all_panels) [p_name(p) == "rear" ? "rear_panel" : p_name(p), "wood", p_w(p) + (panel_tabs_eligible(p) ? 2 * joinery_tab_depth : 0), p_len(p), 1]];
function side_parts() = concat(
    [["left_side", "wood", c_D + (c_is_arcade ? c_O : 0), c_H, 1], ["right_side", "wood", c_D + (c_is_arcade ? c_O : 0), c_H, 1]],
    c_tab_blind ? [["left_side_pockets", "pockets", c_D + (c_is_arcade ? c_O : 0), c_H, 1], ["right_side_pockets", "pockets", c_D + (c_is_arcade ? c_O : 0), c_H, 1]] : []);
function extra_parts() = concat(
    c_rsd_on ? [["rear_service_door", "wood", c_rsd_w, c_rsd_h, 1]] : [],
    c_coin_door ? [["coin_door", "wood", coin_door_width, coin_door_height, 1]] : [],
    c_kd_on ? [["keyboard_drawer_front", "wood", c_kd_w, c_kd_h, 1]] : [],
    vesa_mount_panel_enabled && vesa_adjustable() ? [["vesa_mount_panel", "wood", vesa_mount_panel_w() + 2 * T, vesa_mount_panel_h(), 1], ["vesa_adjust_rail", "wood", vesa_adjust_rail_depth(), vesa_adjust_rail_h(), 2]] : [],
    c_backbox_on ? [["vpin_backbox_side", "wood", c_bb_d, c_bb_h, 2], ["vpin_backbox_front", "wood", c_bb_iw, c_bb_h, 1], ["vpin_backbox_rear", "wood", c_bb_iw, c_bb_h, 1],
                    ["vpin_backbox_top", "wood", c_bb_iw, c_bb_d, 1], ["vpin_backbox_bottom", "wood", c_bb_iw, c_bb_d - T, 1]] : []);
function plexi_parts() = concat(
    panel_exists("control_panel") ? [["control_plexi", "plexi", IW, part_len("control_panel"), 1]] : [],
    [["screen_plexi", "plexi", IW, screen_len(), 1]],
    c_marquee_on ? [["marquee_plexi", "plexi", IW, part_len("marquee_frame"), 1]] : [],
    c_backbox_on ? [["vpin_backbox_plexi", "plexi", c_bb_iw, c_bb_h, 1]] : []);
function wood_parts() = concat(side_parts(), cross_panel_parts(), extra_parts());
function all_parts() = concat(wood_parts(), plexi_parts());
function part_known(name) = len([for (p = all_parts()) if (p[0] == name) p]) > 0;

module export_named_part(name) {
    assert(part_known(name), str("part_name '", name, "' does not exist in this configuration. Use output_mode=\"part_list\" to see the available parts."));
    part_2d(name);
}

// Simple row packer: parts are laid left to right in rows no wider than
// layout_row_width. Not an optimised nest; it is an overview for checking
// sizes and counts before real nesting in CAM.
function row_assign(parts, i=0, x=0, y=0, rowh=0, acc=[]) =
    i >= len(parts) ? acc :
    let(p = parts[i], w = p[2], h = p[3],
        wrap = x > 0 && x + w > layout_row_width,
        nx = wrap ? 0 : x, ny = wrap ? y + rowh + layout_gap : y, nrowh = wrap ? h : max(rowh, h))
    row_assign(parts, i + 1, nx + w + layout_gap, ny, nrowh, concat(acc, [[p[0], nx, ny]]));

module expand_qty(parts) { }
function with_qty(parts) = [for (p = parts) for (k = [0:p[4]-1]) p];

module sheet_layout(parts) {
    placed = row_assign(with_qty(parts));
    for (e = placed) {
        name = e[0];
        off = (name == "left_side" || name == "right_side" || name == "left_side_pockets" || name == "right_side_pockets")
              ? [name == "right_side" || name == "right_side_pockets" ? c_D : (c_is_arcade ? c_O : 0), 0]
              : [tab_offset(name), 0];
        translate([e[1] + off[0], e[2] + off[1]]) part_2d(name);
    }
}
function tab_offset(name) = let(p = panel_by_name(name == "rear_panel" ? "rear" : name)) is_undef(p) ? 0 : (panel_tabs_eligible(p) ? joinery_tab_depth : 0);

module wood_sheet_2d() { sheet_layout([for (p = wood_parts()) if (p[1] == "wood") p]); }
module plexi_sheet_2d() { sheet_layout(plexi_parts()); }

module print_part_list() {
    echo("Available part_name values for this configuration:");
    for (p = all_parts()) echo(str("  ", p[0], "  (", p[1], ", ", p[4], "x)"));
}

module print_bom() {
    echo(str("BOM: ", c_style, " cabinet, preset=", design_preset, ", stock=", T, " mm, plexi=", PT, " mm"));
    echo(str("Overall: W=", c_W, " D=", c_D + (c_is_arcade ? c_O : 0), " H=", c_H + c_vpin_Z0 + (c_backbox_on ? c_bb_h : 0), " mm (incl. control overhang / legs / backbox)"));
    echo("part, material, width_mm, length_mm, qty");
    for (p = all_parts()) echo(str(p[0], ", ", p[1], ", ", round(p[2] * 10) / 10, ", ", round(p[3] * 10) / 10, ", ", p[4]));
    wood_area = [for (p = wood_parts()) if (p[1] == "wood") p[2] * p[3] * p[4]];
    echo(str("Wood area (parts only, no kerf): ", round(sum_list(wood_area) / 1e4) / 100, " m^2; 2440x1220 sheets at 70% yield: ", ceil(sum_list(wood_area) / (2440 * 1220 * 0.7))));
}
function sum_list(v, i=0) = i >= len(v) ? 0 : v[i] + sum_list(v, i + 1);
