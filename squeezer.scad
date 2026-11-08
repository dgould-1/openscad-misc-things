
linear_extrude(3) {
    difference() {
        union() {
            circle(d=50);
            polygon([
                [-23, 0],
                [-23, 35],
                [-10, 20]
            ]);
            polygon([
                [23, 0],
                [23, 35],
                [10, 20]
            ]);
        }
        translate([-14, -7]) square([28, 2]);
    }
}