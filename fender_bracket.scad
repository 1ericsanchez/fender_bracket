// Fender bracket for Canyon Grizl
// Attaches to outward facing mount points at top of seat stays
// Designed since there is no seat stay brace with an accessory mount point
// common on other bikes.
// 
// Author: Eric Sanchez
// Date: 2025-09-27

// Number of sides for circles, if setting this low, make sure that smallest diameter still fits screw and screw head
resolution = 100;
$fn = resolution;

height = 13;
y_offset = 3;
width = 89;
x_offset = 22;
thickness = 5;
bracket_depth = 17 + thickness;
screw_radius = 5.5 / 2; // M5 screw thread diameter + ~.5 mm tolerance;
screw_head_radius = 9 / 2; // M5 screw head + ~.6 mm tolerance
cylinder_length = 600;  // Something long enough to cut through the bracket
center_slot_width = 10;
recess_depth = 1;
x_hole_slot_width = 2;

module arch() {
    let(
        v1 = [-width/2,0],
        v2 = [-width/2,height],
        v3 = [(-width/2) + x_offset, height + y_offset],
        v4 = [width/2 - x_offset, height + y_offset],
        v5 = [width/2, height],
        v6 = [width/2, 0],
        v7 = [width/2 - x_offset, y_offset],
        v8 = [(-width/2) + x_offset, y_offset]
    )
    linear_extrude(height = thickness)
        polygon(points=[v1,v2,v3,v4,v5,v6,v7,v8]);
}

module side() {
    square([thickness, height], center = false);
}

module x_holes() {
    rotate([0,90,0])
        translate([-(bracket_depth / 2) - (thickness / 2), (height / 2), 0])
            hull() {
                translate([x_hole_slot_width / 2,0,0]) cylinder(h = 500, r = screw_radius, center = true);
                translate([-(x_hole_slot_width / 2),0,0]) cylinder(h = 500, r = screw_radius, center = true);
            }
}

// Explanation:
// First cylinder is a hole the diameter of the screw head.
// Second cylinder is gap between the inside faces of the screws, make it diameter + 1 to subtract from the volume of the first cylinder
module x_hole_recess() {
    rotate([0,90,0])
        translate([-(bracket_depth / 2) - (thickness / 2), (height / 2), 0 ])
            difference() {
                hull() {
                    translate([x_hole_slot_width / 2,0,0]) cylinder(h = 500, r = screw_head_radius, center = true);
                    translate([-(x_hole_slot_width / 2),0,0]) cylinder(h = 500, r = screw_head_radius, center = true);
                }
                hull() {
                    translate([x_hole_slot_width / 2,0,0]) cylinder(h = width + (2 * (thickness - recess_depth)), r = screw_head_radius + 1, center = true);
                    translate([-(x_hole_slot_width / 2),0,0]) cylinder(h = width + (2 * (thickness - recess_depth)), r = screw_head_radius + 1, center = true);
                }
            }
}

module bracket() {
    union() {
        // left side
        linear_extrude(height = bracket_depth)
            translate([-width/2 - thickness, 0, thickness])
                side();

        // arch
        arch();

        // right side
        linear_extrude(height = bracket_depth)
            translate([width/2, 0, thickness])
                side();
    }
}

module center_slot() {
    linear_extrude(height = 10 * thickness, center = true) {
        translate([- (center_slot_width / 2), (height) / 2 + y_offset, 0])
            hull() {
                translate([center_slot_width, 0, 0]) circle(screw_radius);
                circle(screw_radius);
            }
    }
}

scale([1,1,1]){
    // union() {
    difference() {
        bracket();
        x_holes();
        center_slot();
        x_hole_recess();
    }
}