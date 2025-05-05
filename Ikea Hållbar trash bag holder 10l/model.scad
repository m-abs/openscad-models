include <../libraries/BOSL2/std.scad>

module make()
{
    width = 185;
    depth = 232;
    height = 10;
    wall = 4;
    corner = 19;

    middle_inner = 40;
    middle_indent = 10;
    middle = middle_inner + middle_indent * 2;

    $fn = 120;

    diff()
    {
        rect_tube(h = height, size = [ width, depth ], wall = wall, rounding = corner)
        {
            tag("remove") cuboid(size = [ width, middle, height ]);
            tag("keep")
            {
                /*
                position(LEFT) right(middle_indent - wall) cuboid(size = [ wall, middle_inner, height ], anchor = LEFT);
                position(RIGHT) left(middle_indent - wall)
                    cuboid(size = [ wall, middle_inner, height ], anchor = RIGHT);
                    */

                move_indent_in = (middle_inner + middle_indent) / 2 - 1;
                rot_indent = -30;
                move_indent_side = 3.3;
                indent_size = [ wall, middle_indent * 1.59, height ];

                for (i = [ -1, 1 ])
                {
                    middle_size = [ wall, middle_inner, height ];

                    position(i == -1 ? LEFT : RIGHT) left((middle_indent - wall) * i)
                        cuboid(size = middle_size, anchor = i == -1 ? LEFT : RIGHT);

                    for (j = [ -1, 1 ])
                    {
                        position(i == -1 ? LEFT : RIGHT) left(move_indent_side * i) back(move_indent_in * i * j)
                            zrot(rot_indent * j)
                                cuboid(size = indent_size, anchor = i == -1 ? LEFT : RIGHT, rounding = wall / 2,
                                       edges = [ FRONT, BACK ], except_edges = [ TOP, BOTTOM ]);
                    }
                }
            }
        }
    }
}

make();