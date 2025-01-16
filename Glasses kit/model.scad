include <../libraries/BOSL2/std.scad>

mode = "drawer"; // [drawer, outer_case]

module model_cuboid(length, width, height, anchor = CENTER)
{
    rounding = height / 2;
    cuboid([ length, width, height ], rounding = rounding, anchor = anchor, except = [ LEFT, RIGHT ], $fn = 120)
    {
        children();
    }
}

module inner_drawer(anchor, padding = 0)
{
    model_cuboid(drawer_length, drawer_width + padding, drawer_height + padding, anchor = anchor)
    {
        children();
    }
}

wall_thickness = 1.15;

// Spray bottle size
sb_length = 63;
sb_diameter = 13;

inner_length = 86;
inner_width = sb_diameter * 3;
inner_height = sb_diameter + 0.5;

rounding = inner_height / 2;

drawer_length = inner_length;
drawer_width = inner_width + 2 * wall_thickness;
drawer_height = inner_height + 2 * wall_thickness;

outer_length = drawer_length + 2 * wall_thickness;
outer_width = drawer_width + 2 * wall_thickness;
outer_height = drawer_height + 2 * wall_thickness;

outer_rounding = outer_height / 2;

module outer_case()
{
    diff()
    {
        model_cuboid(outer_length, outer_width, outer_height, anchor = BOTTOM)
        {
            tag("remove") position(LEFT) inner_drawer(LEFT, padding = 0.1);
        }
    }
}

module spray_bottle_tube()
{
    diff()
    {
        tube(ir = inner_height / 2, h = inner_length, wall = wall_thickness, anchor = FWD + TOP, orient = LEFT,
             teardrop = true, $fn = 120)
        {
            tag("remove") position(FRONT) back(2) cyl(inner_length, sb_diameter / 3, anchor = CENTER);
        }
    }
}

module drawer()
{
    diff()
    {
        inner_drawer(LEFT + BOTTOM)
        {
            position(LEFT)
            {
                tag("remove") model_cuboid(inner_length, inner_width, inner_height, anchor = LEFT);

                left(wall_thickness * 2) model_cuboid(wall_thickness * 2, outer_width, outer_height, anchor = LEFT);
            }
        }
    }

    // Tube for the spray bottle
    up(inner_height / 2 + wall_thickness) back(inner_height / 2 - 2 * wall_thickness) spray_bottle_tube();
}

if (mode == "drawer")
{
    drawer();
}
else if (mode == "outer_case")
{
    outer_case();
}