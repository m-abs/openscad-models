include <../libraries/BOSL2/std.scad>

width = 250;
length = 250;
height = 300;

inner_height = 50;

module model()
{
    outer_wall = 2;

    inner_width = max(width * 0.3, 30);
    inner_length = max(length * 0.3, 30);

    water_input_offset = 15;
    water_input_size = 30;
    water_hole_r = 2.25;

    // Make the connection between the water and the soil.
    module water_hole()
    {
        module water_intake_hole()
        {
            up(outer_wall * 2 + water_hole_r) xrot(90) cyl(h = max(inner_width, inner_length), r = water_hole_r);
        }

        // Space needed for the water intake holes
        // r*3 gives us diameter of the hole plus sensible padding.
        hole_size = (water_hole_r * 3);

        // Number of holes vertically
        num_vertical_holes = floor(inner_height / hole_size) - 1;

        // Number of holes horizontally width side.
        width_side_length = (inner_width - outer_wall * 2);
        num_width_side_holes = floor(width_side_length / hole_size) - 1;

        // Number of holes horizontally length side.
        long_side_length = (inner_length - outer_wall * 2);
        num_long_side_holes = floor(long_side_length / hole_size) - 1;

        // Make the holes in the long side
        left(num_width_side_holes * hole_size / 2) for (i = [0:1:num_vertical_holes])
        {
            up(i * hole_size)
            {
                water_intake_hole();
                for (j = [0:1:num_width_side_holes])
                {
                    right(j * hole_size) water_intake_hole();
                }
            }
        }

        // Make the holes in the width side
        fwd(num_long_side_holes * hole_size / 2) for (i = [0:1:num_vertical_holes])
        {
            zrot(90) up(i * hole_size)
            {
                water_intake_hole();
                for (j = [0:1:num_long_side_holes])
                {
                    right(j * hole_size) water_intake_hole();
                }
            }
        }
    }

    // Make the water input funnel
    module water_funnel()
    {
        cuboid([ water_input_size, water_input_size, height + water_input_offset ], rounding = outer_wall / 2,
               anchor = BACK + TOP, edges = "Z")

        {
            tag("remove") up(outer_wall)
                cuboid([ water_input_size - outer_wall, water_input_size - outer_wall, height + water_input_offset ],
                       rounding = outer_wall / 2, edges = "Z");
            up(outer_wall) fwd(outer_wall) tag("remove") position(BOTTOM) wedge([ 30, 30, 30 ], anchor = BOTTOM);
        }
    }

    diff()
    {
        rect_tube(h = height, size = [ width, length ], wall = outer_wall, rounding = outer_wall, anchor = BOTTOM)
        {
            position(BOTTOM)
            {
                cuboid([ width, length, outer_wall ], rounding = outer_wall, anchor = BOTTOM, edges = "Z");

                up(inner_height + outer_wall)
                    rect_tube(h = 30, size2 = [ width, length ], size1 = [ inner_width, inner_length ],
                              wall = outer_wall, rounding = outer_wall, anchor = BOTTOM);

                up(outer_wall) rect_tube(h = inner_height, size = [ inner_width, inner_length ], wall = outer_wall,
                                         rounding = outer_wall, anchor = BOTTOM)
                {
                    tag("remove") position(BOTTOM) water_hole();
                }
            }

            up(water_input_offset) position(BACK + TOP) water_funnel();
        }
    }
}

model();