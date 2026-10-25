// Render helper: include the generator with output_mode="none"-like behaviour by
// calling assembly() under a model rotation, so the CLI camera can stay fixed.
//   openscad -o out.png --camera=0,0,0,0,0,0 --autocenter --viewall -D 'view="side"' tests/view.scad
view = "iso";   // iso | side | cut | rear | front | top | part | sheet
yaw = 215; tilt = -25;
include <../arcade_cabinet_workshop.scad>
output_mode = "none";   // the generator's own main does nothing; scene() draws
module scene() {
    if (view == "part") rotate([90, 0, 0]) linear_extrude(1) part_2d(part_name);
    else if (view == "sheet") rotate([90, 0, 0]) linear_extrude(1) wood_sheet_2d();
    else if (view == "iso") rotate([tilt, 0, 0]) rotate([0, 0, yaw]) assembly();
    else if (view == "rear") rotate([tilt, 0, 0]) rotate([0, 0, 35]) assembly();
    else if (view == "side") rotate([0, 0, -90]) assembly();
    else if (view == "front") rotate([0, 0, 180]) assembly();
    else if (view == "top") rotate([-90, 0, 0]) rotate([0, 0, 180]) assembly();
    else if (view == "cut") rotate([0, 0, -90]) difference() { assembly(); translate([-1, -3000, -1]) cube([c_W / 2 + 1, 8000, 8000]); }
}
scene();
