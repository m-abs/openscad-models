include <../libraries/BOSL2/std.scad>

module make()
{
    $fn = 180;

    parts = 4;
    angle = 360 / parts;
    num_pegs = 16 / parts;
    peg_height = 5;
    peg_offset = 2;

    radius = 325 / 2;
    wall = 2;
    height = 80;

    rotate_extrude(angle = angle) translate([ radius, 0, 0 ]) square(size = [ wall, height ]);

    for (i = [0:1:num_pegs - 1])
    {
        zmove(height - peg_offset) rot(a = 90 / num_pegs * i, cp = [ 0, 0 ]) #rotate_extrude(angle = angle / 4 / 4)
            translate([ radius - wall + 0.01, 0, 0 ]) square(size = [ wall, peg_height + peg_offset ]);
    }

    for (i = [ -1, 1 ])
    {
        rot(a = -2, cp = [ 0, 0 ]) rotate_extrude(angle = 4) translate([ radius + wall * i, 0, 0 ])
            square(size = [ wall, height ]);
    }
}

make();