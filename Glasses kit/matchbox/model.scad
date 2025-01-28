include <../libraries/BOSL2/std.scad>

mode = "Make container"; // [Make container, Make lid]
module model()
{
    wall = 2.5;
    half_wall = wall / 2;

    // Spray bottle size
    sb_length = 63;
    sb_diameter = 13;

    container_length = 90;
    container_width = sb_diameter * 4;
    container_height = sb_diameter + wall + 0.5;

    container_size = [ container_width, container_height ];
    container_rounding = half_wall / 2;

    if (mode == "Make lid")
    {
        rect_tube(h = container_length, isize = container_size, wall = half_wall, anchor = BOTTOM,
                  rounding = container_rounding, $fn = 180)
        {
            position(BACK) fwd(half_wall) cuboid([ container_width - wall - 0.002, half_wall, container_length ]);
        }
    }
    else if (mode == "Make container")
    {
        diff()
        {
            rect_tube(h = container_length, size = container_size, wall = half_wall, anchor = BOTTOM,
                      rounding = container_rounding, $fn = 180)
            {
                for (pos = [ TOP, BOTTOM ])
                {
                    position(pos) cuboid([ container_width, container_height, half_wall ], anchor = pos,
                                         rounding = container_rounding, edges = [ LEFT, RIGHT ]);
                }

                position(LEFT) right(sb_diameter + wall)
                    cuboid([ half_wall / 2, container_height, container_length ], anchor = LEFT);

                tag("remove") position(BACK) fwd(half_wall / 2)
                    cuboid([ container_width - wall, half_wall + 0.002, container_length ]);
            }
        }
    }
}

model();