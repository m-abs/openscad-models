include <../libraries/BOSL2/std.scad>
include <./constants.scad>

$fn = 180;

module pole(padding = 0)
{
    color("lightgrey") linear_extrude(height = pool_height, center = true)
    {
        for (i = [0:1])
        {
            glued_circles(r = (pole_radius + padding) / 2, spread = pole_radius + padding, spin = 90 * i);
        }
    }
}

module cone(height_padding = 5, size_padding = 0)
{
    h = cone_height + height_padding;
    r1 = cone_bottom_radius + size_padding;
    r2 = cone_top_radius + size_padding;

    cyl(h = h, r1 = r1, r2 = r2, center = true);
}

module footer_cone()
{
    difference()
    {
        // Outer cone
        color("lightblue") cone();

        // Cut out grooves in the sides
        for (i = [0:1])
        {
            cube([ 4, cone_bottom_radius * 2, cone_height + 4 ], center = true, spin = 90 * i);
        }

        // Cut out a hole in the top
        pole(2);
    }

    // Add the inner cone
    color("lightgreen") cone(size_padding = -2);
}

module pole_with_cone()
{
    up(pool_height / 2 + thickness / 2)
    {
        pole();
        down((pool_height - 20) / 2) footer_cone();
    }
}

module bottom_round_end()
{
    cyl(h = thickness, r = foot_width / 2, center = true);
}

module bottom_piece()
{
    // Length of the bottom piece without the round ends
    p_length = foot_length - foot_width / 2;

    // Middle bar
    cuboid([ p_length, foot_width, thickness ], rounding = 5, edges = TOP);

    // Round ends
    round_move = p_length / 2 - 2;
    left(round_move) bottom_round_end();
    right(round_move) bottom_round_end();

    // Add the poles.
    pole_offset = foot_length / 2 - pole_diameter;
    left(pole_offset) yrot(10) pole_with_cone();
    right(pole_offset) yrot(-10) pole_with_cone();
}

module build()
{
    bottom_piece();
    zrot(90) bottom_piece();
}

build();