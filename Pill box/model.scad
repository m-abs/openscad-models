include <../libraries/BOSL2/std.scad>

mode = "pill_box"; // [pill_box, lids]
week_days = [ "M", "Ti", "O", "To", "F", "L", "S" ];

module make()
{
    wall = 2;

    depth = 35;

    container_width = 23;
    container_height = 20;

    lid_height = wall;
    lid_width1 = container_width - wall;
    lid_width2 = container_width - 2 * wall;

    module lid_base_shape(anchor = BOTTOM + CENTER)
    {
        cuboid([ lid_width1, depth + 0.001, lid_height ], anchor = anchor, rounding = lid_height / 2,
               except = [ FRONT, BACK ], $fn = 3)
        // prismoid(size1 = [ lid_width1, depth ], size2 = [ lid_width2, depth ], h = lid_height, anchor = anchor)
        {
            children();
        }
    }

    module lid(text)
    {
        diff()
        {
            lid_base_shape()
            {
                position(TOP) tag("remove") text3d(text = text, h = 0.5, anchor = CENTER, center = true);
                position(BACK + TOP) fwd(1) cyl(r = 1, l = lid_width2, $fn = 8, orient = LEFT);
                position(FRONT + TOP) back(1) cyl(r = 1, l = lid_width2, $fn = 8, orient = LEFT);
            }
        }
    }

    module pill_box()
    {
        diff()
        {
            rect_tube(h = container_height, size = [ container_width, depth ], wall = wall, anchor = BOTTOM)
            {
                tag("remove") position(TOP) lid_base_shape(TOP);
            };
            cube([ container_width, depth, wall ], anchor = BOTTOM);
        }
    }

    for (i = [0:1:6])
    {
        right(container_width * i)
        {
            if (mode == "lids")
            {
                lid(week_days[i]);
            }
            else
            {
                if (i == 0)
                {
                    left((container_width + wall) / 2) cube([ wall, depth, container_height ], anchor = BOTTOM);
                }

                pill_box();

                if (i == 6)
                {
                    right((container_width + wall) / 2) cube([ wall, depth, container_height ], anchor = BOTTOM);
                }
            }
        }
    }

    /*
        pill_box();
        left(container_width) lid("M", "da");
        */
}

make();