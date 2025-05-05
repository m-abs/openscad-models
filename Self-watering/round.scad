include <../libraries/BOSL2/std.scad>

diameter = 200;
height = 260;

inner_height = 40;

module model()
{
    outer_wall = 4;
    inner_wall = 2.5;

    water_hole_r = 5;
    water_input_offset = 30;
    water_input_size = 30;

    inner_diameter = max(diameter * 0.3, 30);
    module water_intake_hole()
    {
        xrot(90) cyl(h = inner_diameter, r = water_hole_r, $fn = 4);
    }

    // Make the connection between the water and the soil.
    module water_hole()
    {
        // Space needed for the water intake holes
        // r*3 gives us diameter of the hole plus sensible padding.
        hole_size = (water_hole_r * 3);

        // Number of holes vertically
        num_vertical_holes = floor(inner_height / hole_size);

        hole_angle = 45;
        for (i = [0:1:360 / hole_angle - 1])
        {
            for (j = [0:1:num_vertical_holes])
            {
                z_rot = j % 2 == 0 ? i * hole_angle : i * hole_angle + hole_angle / 2;
                up(j * hole_size) zrot(z_rot) water_intake_hole();
            }
        }
    }

    // Make the water input funnel
    module water_funnel()
    {
        water_input_height = height + water_input_offset - inner_height * 2;

        up(inner_height * 2 - 18 + 0.1) cuboid([ water_input_size, water_input_size, water_input_height ],
                                               rounding = inner_wall / 2, anchor = BOTTOM, edges = "Z")

        {
            water_input_size_inner = water_input_size - inner_wall * 2;
            tag("remove")
            {
                cuboid([ water_input_size_inner, water_input_size_inner, water_input_height ],
                       rounding = inner_wall / 2, edges = "Z");
                fwd(inner_wall) position(BOTTOM)
                    wedge([ water_input_size, water_input_size, water_input_size / 2 + 2 ], anchor = BOTTOM);
            }
        }
    }

    diff()
    {
        up(inner_height)
            tube(h = inner_height, od2 = diameter, od1 = inner_diameter, wall = inner_wall, anchor = BOTTOM, $fn = 360)
        {
            down(inner_height)
            {
                tube(h = inner_height, od = inner_diameter, wall = inner_wall, $fn = 360)
                {
                    position(BOTTOM) tag("remove") water_hole();
                }
            }
        }

        fwd((diameter - water_input_size) / 2 - outer_wall) water_funnel();

        num_support = 5;
        support_degrees = 360 / num_support;
        tag("keep") for (i = [1:1:num_support])
        {
            zrot(i * support_degrees) fwd(60) cyl(h = inner_height * 1.48, d1 = 10, d2 = 8, anchor = BOTTOM + CENTER);
        }
    }
}

model();