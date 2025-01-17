include <../libraries/BOSL2/std.scad>

mode = "Make container"; // [Make container, Make lid]

module model_cuboid(length, width, height, anchor = CENTER)
{
    rounding = height / 2;
    cuboid([ length, width, height ], rounding = rounding, anchor = anchor, except = [ LEFT, RIGHT ], $fn = 120)
    {
        children();
    }
}

module inner_space(anchor)
{
    model_cuboid(drawer_length - lid_inner_length, drawer_width, drawer_height, anchor = anchor)
    {
        position(RIGHT) right(lid_inner_length / 2) model_cuboid(lid_inner_length, drawer_width + -wall_thickness,
                                                                 drawer_height + -wall_thickness, anchor = CENTER);
        children();
    }
}

wall_thickness = 2.5;

// Spray bottle size
sb_length = 63;
sb_diameter = 13;

inner_length = 86;
inner_width = sb_diameter * 4;
inner_height = sb_diameter + 0.5;

drawer_length = inner_length;
drawer_width = inner_width + 2 * wall_thickness;
drawer_height = inner_height + 2 * wall_thickness;

lid_inner_length = 20;
lid_length = lid_inner_length + wall_thickness;
lid_width = drawer_width;
lid_height = drawer_height;

module top_lid()
{
    diff()
    {
        model_cuboid(lid_length, lid_width, lid_height, anchor = LEFT + BOTTOM)
        {
            position(RIGHT) left(wall_thickness / 2) tag("keep") model_cuboid(wall_thickness, lid_width, lid_height);
            tag("remove")
            {
                position(LEFT) inner_space(RIGHT);
                position(RIGHT) left(lid_inner_length / 3) cyl(h = lid_height, r = 0.25);
            }
        }
    }
}

module spray_bottle_tube()
{
    difference()
    {
        fwd(wall_thickness / 2 + 0.1) tube(ir = inner_height / 2, h = sb_length, wall = wall_thickness / 2,
                                           anchor = BACK, orient = LEFT, teardrop = true, $fn = 120);
        fwd(inner_height + sb_diameter / 3.5) cyl(sb_length, sb_diameter / 3.5, orient = LEFT);
    }
}

module make_container()
{
    diff()
    {
        inner_space(LEFT + BOTTOM)
        {
            position(LEFT)
            {
                // Make hollow space.
                tag_this("remove") model_cuboid(inner_length * 2, inner_width, inner_height, anchor = LEFT);

                // Bottom wall
                left(wall_thickness) tag_this("keep")
                    model_cuboid(wall_thickness, drawer_width, drawer_height, anchor = LEFT);
            }

            // Tube for the spray bottle
            position(BACK) tag_this("keep") spray_bottle_tube();
        }
    }
}

if (mode == "Make container")
{
    make_container();
}
else if (mode == "Make lid")
{
    top_lid();
}