// tp_protector.scad
// David Gould 2026

use <inc/library.scad>

// rendering resolution for curves
$fn = 256;


// constant parameters (actual measurements of a TP roll)
roll_od     = in(4.5);
roll_id     = in(1.75);
roll_length = in(4);

// configuration parameters
thickness     = in(3/16);     // make all parts this thick
guard_extra_r = in(3/4);      // make the guard this much bigger than the outside of the roll (on each side)
guard_extra_l = thickness;    // make the guard and axle this much longer than the roll
guard_arc     = deg(120);     // make the guard an arc of this angle
axle_inset    = in(1/8);      // make the axle this much smaller than the inside of the roll (on each side)

// computed parameters
guard_od     = roll_od + 2 * guard_extra_r;
guard_id     = guard_od - 2 * thickness;
guard_length = roll_length + thickness + guard_extra_l;
axle_od      = roll_id - 2 * axle_inset;
axle_id      = axle_od - 2 * thickness;
knob_radius  = (guard_od + guard_id) / 4;

// subtract the axle's inner-diameter cylinder from the guard and axle
difference() {
    
    // construct guard plus axle
    union() {

        // construct the guard (shell plus base, chopped to an arc of guard_arc degrees)
        difference() {
            
            // construct the guard (shell plus base)
            union() {
                
                // guard shell: an outer-diameter cylinder minus an inner-diameter cylinder
                difference() {
                    cylinder(guard_length, guard_od/2, guard_od/2);
                    
                    translate([0, 0, -1/2]) // make subtracted parts a little bigger, for clean rendering
                        cylinder(guard_length + 1, guard_id/2, guard_id/2);
                }
                
                // guard base: a thin outer-diameter cylinder
                cylinder(thickness, guard_od/2, guard_od/2);
            }
            
            // chop off half (180 degrees)
            translate([-(guard_od + 1)/2, 0, -1/2])
                cube([guard_od + 1, guard_od, guard_length + 1]); 
            
            // chop off an additional (180 degrees - guard_arc)
            rotate([0, 0, deg(180) - guard_arc])
                translate([-(guard_od + 1)/2, 0, -1/2])
                    cube([guard_od + 1, guard_od, guard_length + 1]);
        }
        

        // add the axle (outer-diameter cylinder)
        cylinder(guard_length, axle_od/2, axle_od/2); 
    }

    // subtract the axle's inner-diameter cylinder
    translate([0, 0, -1/2])
        cylinder(guard_length + 1, axle_id/2, axle_id/2);
}
