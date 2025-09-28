// Fender bracket for Canyon Grizl
// Attaches to outward facing mount points at top of seat stays
// Designed since there is no seat stay brace with a fender mount point
// common to other bikes.
// 
// Author: Eric Sanchez
// Date: 2025-09-27

height = 13;
y_offest = 3;
width = 88;
x_offset = 22;
thickeness = 5;
bracket_depth = 17 + thickeness;

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
