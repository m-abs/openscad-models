include <../libraries/BOSL2/std.scad>

// Select part to make
mode = "Make container"; // [Make container, Make lid]

// Make air hole in the lid
make_air_hole = false;

module make_model()
{
    wall = 2.5;
    half_wall = wall / 2;

    // Spray bottle size
    sb_length = 63;
    sb_diameter = 13;

    inner_length = 86;
    inner_width = sb_diameter * 4;
    inner_height = sb_diameter + 0.5;

    inner_space_length = inner_length;
    inner_space_width = inner_width + 2 * wall;
    inner_space_height = inner_height + 2 * wall;

    lid_inner_length = 20;
    lid_inner_width = inner_space_width + -wall;
    lid_inner_height = inner_space_height + -wall;

    lid_length = lid_inner_length + wall;
    lid_width = inner_space_width;
    lid_height = inner_space_height;

    /**
     * Model a cuboid with rounded sides. Top and bottom are not rounded.
     */
    module model_cuboid(length, width, height, anchor = CENTER)
    {
        // We want a fully rounded side.
        rounding = height / 2;

        cuboid([ length, width, height ], rounding = rounding, anchor = anchor, except = [ LEFT, RIGHT ], $fn = 120)
        {
            children();
        }
    }

    /**
     * Inner lid
     */
    module inner_lid(anchor = CENTER, padding = 0)
    {
        model_cuboid(lid_inner_length, lid_inner_width + padding, lid_inner_height + padding, anchor = anchor);
    }

    /**
     * Make the lid
     */
    module make_lid()
    {
        diff()
        {
            model_cuboid(lid_length + 10, lid_width, lid_height, anchor = LEFT + BOTTOM)
            {
                tag("keep")
                {
                    // Top of the lid
                    position(RIGHT)
                    {
                        left(half_wall)
                        {
                            model_cuboid(wall, lid_width, lid_height);
                        }
                    }
                }

                tag("remove")
                {
                    // Cut out the empty space inside the lid.
                    position(RIGHT)
                    {
                        left(wall + 0.1)
                        {
                            // Make the wider cutout part.
                            inner_lid(RIGHT, -half_wall);

                            // Make the narrower cutout part.
                            left(10)
                            {
                                inner_lid(RIGHT);
                            }
                        }

                        if (make_air_hole)
                        {
                            // Make the air hole in side of the lid
                            left(lid_inner_length + 10)
                            {
                                cyl(h = lid_height, r = 0.35, $fn = 6);
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     * Tube for the spray bottle to be in the container
     */
    module spray_bottle_tube()
    {
        // Use built-in difference to avoid conflict with nested diff() functions in BOSL2.
        difference()
        {
            // Make the tube for the spray bottle
            fwd(half_wall + 0.1)
            {
                tube(ir = inner_height / 2, h = sb_length, wall = half_wall, anchor = BACK, orient = LEFT,
                     teardrop = true, $fn = 120);
            }

            // Cut out an opening in the tube.
            fwd(inner_height + sb_diameter / 3.5)
            {
                cyl(sb_length, sb_diameter / 3.5, orient = LEFT);
            }
        }
    }

    /***
     * Make the container part
     */
    module make_container()
    {
        diff()
        {
            // Make the wider part of the container
            model_cuboid(inner_space_length - lid_inner_length, inner_space_width, inner_space_height,
                         anchor = LEFT + BOTTOM)
            {
                // Add the narrower part of the container, this is where the lid is connected.
                position(RIGHT)
                {
                    right(lid_inner_length / 2)
                    {
                        inner_lid();
                    }
                }

                position(LEFT)
                {
                    // Cutout the inner space.
                    tag_this("remove")
                    {
                        model_cuboid(inner_length * 2, inner_width, inner_height, anchor = LEFT);
                    }

                    // Add the bottom.
                    tag_this("keep")
                    {
                        left(wall)
                        {
                            model_cuboid(wall, inner_space_width, inner_space_height, anchor = LEFT);
                        }
                    }
                }

                // Add the tube for the spray bottle
                position(BACK)
                {
                    tag_this("keep")
                    {
                        spray_bottle_tube();
                    }
                }
            }
        }
    }

    if (mode == "Make container")
    {
        make_container();
    }
    else if (mode == "Make lid")
    {
        make_lid();
    }
}

make_model();