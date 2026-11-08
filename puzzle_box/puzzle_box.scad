// puzzle_box.scad
// David Gould 2026

use <inc/library.scad>

// rendering resolution for curves
$fn = 100;


// plate selection
plate = "top";
//plate = "bottom";
//plate = "long_sides";
//plate = "short_sides";


// constant parameters (actual measurements of the box)

full_width  = in(9+27/32);
full_length = in(7+7/8);

side_width  = in(9+1/2);
side_length = in(7+9/16);
side_height = in(2);

thickness = in(3/16);

slot_width = in(1+3/16);
slot_inset = in(23/32);

hole_diameter_side = in(1+3/16);


// configuration parameters

round_radius = in(1/8);


// computed parameters

panel_width  = full_width  - round_radius * 2;
panel_length = full_length - round_radius * 2;


// top-level geometry

//translate([-128, -128, -3]) cube([256, 256, 3]);

if (plate == "top") {
    //translate([-panel_width/2, -panel_length/2, 0])
        top();
}

if (plate == "bottom") {
    //translate([-panel_width/2, -panel_length/2, 0])
        bottom();
}

if (plate == "long_sides") {
    translate([-side_width/2, in(1/2), 0]) long_side();
    translate([-side_width/2, -side_height - in(1/2), 0]) long_side();
}

if (plate == "short_sides") {
    translate([-side_length/2, in(1/2), 0]) short_side();
    translate([-side_length/2, -side_height - in(1/2), 0]) short_side();
}


// modules

module panel(holes) {

    side_inset_x = full_width/2 - side_width/2;
    side_inset_y = full_length/2 - side_length/2;
    
    slot_h_x1 = side_inset_x + slot_inset;
    slot_h_x2 = full_width - (side_inset_x + slot_inset + slot_width);
    
    slot_h_y1 = side_inset_y;
    slot_h_y2 = full_length - side_inset_y - thickness;
    
    slot_v_x1 = side_inset_x;
    slot_v_x2 = full_width - side_inset_x - thickness;
    
    slot_v_y1 = side_inset_y + slot_inset;
    slot_v_y2 = full_length - (side_inset_y + slot_inset + slot_width);
    
    module draw(hole, i = 1) {
        diameter = hole[0];
        if (i == len(hole) - 1) {
            translate(hole[i]) circle(d=diameter);
        } else {
            hull() {
                translate(hole[i]) circle(d=diameter);
                translate(hole[i+1]) circle(d=diameter);
            }
            draw(hole, i+1);
        }
    }

    linear_extrude(thickness) {
        difference() {
            offset(r=round_radius) {
                translate([round_radius, round_radius]) {
                    square([panel_width, panel_length]);
                }
            }
            
            for (hole = holes) {
                draw(hole);
            }
            
            translate([slot_h_x1, slot_h_y1]) offset(delta = in(1/128)) square([slot_width, thickness]);
            translate([slot_h_x2, slot_h_y1]) offset(delta = in(1/128)) square([slot_width, thickness]);
            
            translate([slot_h_x1, slot_h_y2]) offset(delta = in(1/128)) square([slot_width, thickness]);
            translate([slot_h_x2, slot_h_y2]) offset(delta = in(1/128)) square([slot_width, thickness]);
            
            translate([slot_v_x1, slot_v_y1]) offset(delta = in(1/128)) square([thickness, slot_width]);
            translate([slot_v_x2, slot_v_y1]) offset(delta = in(1/128)) square([thickness, slot_width]);
            
            translate([slot_v_x1, slot_v_y2]) offset(delta = in(1/128)) square([thickness, slot_width]);
            translate([slot_v_x2, slot_v_y2]) offset(delta = in(1/128)) square([thickness, slot_width]);
        }
    }
}

module top() {
    panel([
        [45, [50, 150]],
        [50, [full_width / 2, full_length / 2]],
        [45, [full_width - 50, full_length - 150]],
        [28, [40, 80], [40, 40], [120, 40]],
        [28, [full_width - 40, full_length - 80], [full_width - 40, full_length - 40], [full_width - 120, full_length - 40]]
    ]);
}


module bottom() {
    panel([]);
}


module side(width, x_holes) {
    length = side_height;
    
    x1 = 0;
    x2 = thickness;
    x3 = width - thickness;
    x4 = width;
    
    y1 = 0;
    y2 = length / 2;
    y3 = length;
    
    x5 = x1 + slot_inset;
    x6 = x5 + slot_width;
    x7 = x4 - slot_inset;
    x8 = x7 - slot_width;
    
    y0 = y1 - thickness;
    y4 = y3 + thickness;
    
    points = [
        // left edge
        [x1, y1],
        [x1, y2],
        [x2, y2],
        [x2, y3],
        
        // top left slot
        [x5, y3],
        [x5, y4],
        [x6, y4],
        [x6, y3],
        
        // top right slot
        [x7, y3],
        [x7, y4],
        [x8, y4],
        [x8, y3],
        
        // right edge
        [x3, y3],
        [x3, y2],
        [x4, y2],
        [x4, y1],
        
        // bottom right slot
        [x8, y1],
        [x8, y0],
        [x7, y0],
        [x7, y1],
        
        // bottom left slot
        [x6, y1],
        [x6, y0],
        [x5, y0],
        [x5, y1]
    ];

    linear_extrude(thickness) {
        difference() {
            polygon(points);
            
            for (x = x_holes) {
                echo("x", x);
                translate([x + hole_diameter_side/2, y2]) {
                    circle(d=hole_diameter_side);
                }
            }
        }
    }
}


module short_side() {
    side(side_length, [in(27/32), in(3+3/16), in(5+9/16)]);
}

module long_side() {
    side(side_width, [in(15/16), in(3+1/16), in(5+9/32), in(7+7/16)]);
}


