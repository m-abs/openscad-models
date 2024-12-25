include <./libraries/BOSL2/std.scad>

radius = 4;
inner_radius = 3.5;

bend_radius = 17;

angle_1 = 10;
angle_2 = 100;

tunnel_width = 20;
tunnel_circle_radius = 9.5;
tunnel_straight_middle = tunnel_width - tunnel_circle_radius * 2;

#right(20) back(20) union()
{
    $fn = 190;
    difference()
    {
        cube([ 40, 40, 40 ], anchor = CENTER);

        left(21) fwd(21) rotate_extrude(angle = 90) translate([ bend_radius + radius, 0, 0 ])
            rect([ tunnel_width, tunnel_width ], rounding = 9.5, anchor = CENTER);
    }

    left(21) fwd(21) rotate_extrude(angle = 90) translate([ bend_radius + radius, 0, 0 ])
        rect([ 2, 2 ], rounding = 0.98, anchor = CENTER);
}

myPath = [ [ 0, 0, 40 ], [ 0, 20, 20 ], [ 0, 40, 20 ], [ 0, 40, 0 ] ];

path_extrude(path = myPath) rect([ tunnel_width, tunnel_width ], rounding = 9.5, anchor = CENTER);
/*
union()
{
    // lower arm
    rotate([ 0, 0, angle_1 ]) translate([ bend_radius + radius, 0.02, 0 ]) rotate([ 90, 0, 0 ]) difference()
    {
        cylinder(r = radius, h = 50);
        translate([ 0, 0, -1 ]) cylinder(r = inner_radius, h = 52);
    }
    // upper arm
    rotate([ 0, 0, angle_2 ]) translate([ bend_radius + radius, -0.02, 0 ]) rotate([ -90, 0, 0 ]) difference()
    {
        cylinder(r = radius, h = 50);
        translate([ 0, 0, -1 ]) cylinder(r = inner_radius, h = 52);
    }

    // bend
    difference()
    {
        // torus
        rotate_extrude() translate([ bend_radius + radius, 0, 0 ]) tunnel2d(r = radius);

        // torus cutout
        rotate_extrude() translate([ bend_radius + radius, 0, 0 ]) tunnel2d(r = inner_radius);

        // lower cutout
        rotate([ 0, 0, angle_1 ]) translate([ -50 * (((angle_2 - angle_1) <= 180) ? 1 : 0), -100, -50 ])
            cube([ 100, 100, 100 ]);
        // upper cutout
        rotate([ 0, 0, angle_2 ]) translate([ -50 * (((angle_2 - angle_1) <= 180) ? 1 : 0), 0, -50 ])
            cube([ 100, 100, 100 ]);
    }
}
*/