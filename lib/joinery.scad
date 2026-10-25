// 2D primitives and side/cross-panel joinery features.

module rounded_rect_2d(w, h, r=0, center=false) {
    rr = min(max(r, 0), min(w, h) / 2);
    if (rr <= 0) square([w, h], center=center);
    else translate(center ? [0, 0] : [w / 2, h / 2])
        hull() for (x = [-w / 2 + rr, w / 2 - rr]) for (y = [-h / 2 + rr, h / 2 - rr])
            translate([x, y]) circle(r=rr, $fn=48);
}

function joinery_active() = panel_joinery != "none";
function tab_joinery() = panel_joinery == "tab_slot";
function screw_joinery() = panel_joinery == "screw";
function joint_u(i, len) = (i + 1) * len / (joinery_count + 1);            // symmetric, so panel reversal does not matter
function joint_feature_len(len) = min(joinery_tab_width, max(10, len / (joinery_count + 1) * 0.75));
function panel_tabs_eligible(p) = joinery_active() && p_joinery(p) && abs(p_w(p) - IW) < 1e-6;

// Cross-panel blank: w across the cabinet, len along the panel; tabs on the
// two long edges that meet the side panels.
module panel_blank(w, len, tabs=false) {
    if (tabs && tab_joinery()) {
        fw = joint_feature_len(len);
        union() {
            square([w, len]);
            for (i = [0:joinery_count-1]) {
                u = joint_u(i, len);
                translate([-joinery_tab_depth, u - fw / 2]) square([joinery_tab_depth, fw]);
                translate([w, u - fw / 2]) square([joinery_tab_depth, fw]);
            }
        }
    } else square([w, len]);
}

// Slot with dogbone relief. Relief circles are pulled in along the diagonal so
// the cutter just reaches the slot corner instead of overshooting it.
module dogbone_slot_2d(len, wid, relief=true) {
    union() {
        square([len, wid], center=true);
        if (relief) {
            r = c_tool_r; k = r / sqrt(2);
            for (sx = [-1, 1]) for (sy = [-1, 1])
                translate([sx * (len / 2 - k), sy * (wid / 2 - k)]) circle(r=r, $fn=32);
        }
    }
}

module capsule_slot_2d(len, wid) {
    ll = max(len, wid);
    hull() {
        translate([-(ll - wid) / 2, 0]) circle(d=wid, $fn=40);
        translate([(ll - wid) / 2, 0]) circle(d=wid, $fn=40);
    }
}

// Features cut into the side panel for one cross panel, in side-view
// coordinates. kind = "through" (screw holes, through tab slots) or "pocket"
// (blind tab pockets, exported separately for CAM depth assignment).
module side_joint_features(p, kind) {
    if (panel_tabs_eligible(p)) {
        len = p_len(p); fw = joint_feature_len(len);
        for (i = [0:joinery_count-1])
            translate(p_o(p)) rotate(p_ang(p)) translate([joint_u(i, len), T / 2]) {
                if (screw_joinery() && kind == "through")
                    circle(d=joinery_screw_hole_diameter, $fn=36);
                else if (tab_joinery() && ((c_tab_through && kind == "through") || (c_tab_blind && kind == "pocket")))
                    dogbone_slot_2d(fw + joinery_slot_clearance, T + joinery_slot_clearance, joinery_dogbone_relief);
            }
    }
}
