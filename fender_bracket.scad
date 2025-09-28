// Fender bracket for Canyon Grizl
// Attaches to outward facing mount points at top of seat stays
// Designed since there is no seat stay brace with a fender mount point
// common to other bikes.
// 
// Author: Eric Sanchez
// Date: 2025-09-27

resolution = 100;
$fn = resolution;

height = 13;
y_offest = 3;
width = 88;
x_offset = 22;
thickeness = 5;
bracket_depth = 17 + thickeness;
screw_diameter = 5.5 / 2; // M5 screw;
cylinder_length = 600;  // Something long enough to cut through the bracket
slot_width = 10;

v1 = [0,0];
v2 = [0,height];
v3 = [x_offset,height+y_offest];
v4 = [width-x_offset,height+y_offest];
v5 = [width,height];
v6 = [width,0];
v7 = [width - x_offset,y_offest];
v8 = [x_offset,y_offest];

module arch() {
    linear_extrude(height = thickeness)
        polygon(points=[v1,v2,v3,v4,v5,v6,v7,v8]);
}

module side() {
    square([thickeness, height], center = false);
}


module x_holes() {
    rotate([0,90,0])
        translate([-(bracket_depth / 2) - (thickeness / 2), (height / 2), 0])
            cylinder(h = 500, r = screw_diameter, center = true);
}


module bracket() {
    union() {
        // left side
        linear_extrude(height = bracket_depth)
            translate([-thickeness, 0, thickeness])
                side();

        // arch
        arch();

        // right side
        linear_extrude(height = bracket_depth)
            translate([width, 0, thickeness])
                side();
    }
}

module slot() {
    linear_extrude(height = 10 * thickeness, center = true) {
        translate([(width / 2) - (slot_width / 2), (height) / 2 + y_offest, 0])
            hull() {
                translate([slot_width,0,0]) circle(screw_diameter);
                circle(screw_diameter);
            }
    }
}

// union() {
difference() {
    bracket();
    x_holes();
    slot();
}