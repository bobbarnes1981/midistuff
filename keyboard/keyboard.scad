/*

midi keyboard plate

*/

plate_length = 160;
plate_width = 60;
plate_thickness = 3;
corner_radius = 3;

switch_spacing = 19.05;
switch_cutout = 14;
switch_clearance = 0.15;

mount_inset_x = 7;
mount_inset_y = 7;
mount_hole_dia = 3.2; 

$fn=64;

module rounded_plate_2d(length, width, radius) {
    offset(r=radius)
        square([length-(2*radius), width-(2*radius)], center=true);
}

module plate() {
    difference() {
        linear_extrude(height=plate_thickness)
            rounded_plate_2d(plate_length, plate_width, corner_radius);
        
        // switch holes (white keys)
        for (i = [0:7]) {
            x = ((i-3)*switch_spacing)-switch_spacing/2;
            translate([x, 0-(switch_spacing/2), -0.1])
                linear_extrude(height=plate_thickness+0.2)
                    square([switch_cutout + 2 * switch_clearance, switch_cutout + 2 * switch_clearance], center=true);
        }
        
        // switch holes (black keys)
        for (i = [0:5]) {
            if (i != 2) {
                x = (i-3)*switch_spacing;
                translate([x, switch_spacing/2, -0.1])
                    linear_extrude(height=plate_thickness+0.2)
                        square([switch_cutout + 2 * switch_clearance, switch_cutout + 2 * switch_clearance], center=true);
            }
        }
        
        // mounting holes
        for (x = [-plate_length/2 + mount_inset_x,
                   plate_length/2 - mount_inset_x]) {
            for (y = [-plate_width/2 + mount_inset_y,
                       plate_width/2 - mount_inset_y]) {
                translate([x, y, -0.1])
                    cylinder(d=mount_hole_dia, h=plate_thickness + 0.2);
            }
        }
    }
}

plate();