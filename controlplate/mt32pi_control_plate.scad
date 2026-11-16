/*
  MT-32 Pi prototype control plate
  Two Gateron / MX-style keyswitches + one KY-040 rotary encoder.

  Print flat, with the underside on the build plate.
  Check the fit of the switch and encoder holes against your actual parts;
  small printer/material differences may require adjusting the clearances.
*/

// ---------- User-adjustable parameters ----------
plate_length       = 64;     // X dimension
plate_width        = 36;     // Y dimension
plate_thickness     = 3;
corner_radius       = 3;

switch_spacing      = 19.05; // MX switch centre-to-centre spacing
switch_cutout       = 14.0;  // nominal MX plate opening; tune for your printer
switch_clearance    = 0.15;  // added to each side of switch opening

encoder_hole_dia    = 7.2;   // KY-040 threaded bushing; measure yours
mount_hole_dia      = 3.2;   // M3 clearance
mount_inset_x       = 7;
mount_inset_y       = 7;

// ---------- Derived positions ----------
switch_x1 = -switch_spacing;
switch_x2 = 0;
encoder_x = switch_spacing;

$fn = 64;

module rounded_plate_2d(length, width, radius) {
    offset(r=radius)
        square([length - 2*radius, width - 2*radius], center=true);
}

module plate() {
    difference() {
        linear_extrude(height=plate_thickness)
            rounded_plate_2d(plate_length, plate_width, corner_radius);

        // MX-style switch openings
        for (x = [switch_x1, switch_x2]) {
            translate([x, 0, -0.1])
                linear_extrude(height=plate_thickness + 0.2)
                    square([
                        switch_cutout + 2*switch_clearance,
                        switch_cutout + 2*switch_clearance
                    ], center=true);
        }

        // KY-040 encoder shaft / threaded-bushing opening
        translate([encoder_x, 0, -0.1])
            cylinder(d=encoder_hole_dia, h=plate_thickness + 0.2);

        // Four M3 mounting holes, inset from the plate edges
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
