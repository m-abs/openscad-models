foot_length = 240;
foot_width = 50;
thickness = 10;

pole_diameter = 16;
pole_radius = pole_diameter / 2;
pool_height = 65;

cone_height = 25;
cone_top_radius = pole_radius;
cone_bottom_radius = foot_width / 2;

$fn = 360;

module pole(padding = 0)
{
    cylinder(h = pool_height, r = pole_radius + padding, center = true);
}

module cone(height_padding = 5, size_padding = 0)
{
    cylinder(h = cone_height + height_padding, r1 = cone_bottom_radius + size_padding,
             r2 = cone_top_radius + size_padding, center = true);
}

module footer_cone()
{
    difference()
    {
        // Outer cone
        cone();

        // Cut out grooves in the sides
        cube([ 1, cone_bottom_radius * 2, cone_height ], center = true);
        cube([ cone_bottom_radius * 2, 1, cone_height ], center = true);

        // Cut out a hole in the top
        pole(2);
    }

    // Add the inner cone
    cone(5, -2);
}

module pole_with_cone()
{
    translate([ 0, 0, pool_height / 2 + thickness / 2 ])
    {
        pole();
        translate([ 0, 0, -(pool_height - 20) / 2 ]) footer_cone();
    }
}

module bottom_round_end()
{
    cylinder(h = thickness, r = foot_width / 2, center = true);
}

module bottom_piece()
{
    // Length of the bottom piece without the round ends
    p_length = foot_length - foot_width / 2;

    // Middle bar
    cube([ p_length, foot_width, thickness ], center = true);

    // Round ends
    translate([ -p_length / 2, 0, 0 ]) bottom_round_end();
    translate([ p_length / 2, 0, 0 ]) bottom_round_end();

    // Add the poles.
    pole_offset = foot_length / 2 - pole_diameter;
    translate([ -pole_offset, 0, 0 ]) rotate([ 0, 10, 0 ]) pole_with_cone();
    translate([ pole_offset, 0, 0 ]) rotate([ 0, -10, 0 ]) pole_with_cone();
}

module build()
{
    translate([ 0, 0, thickness / 2 ])
    {
        bottom_piece();
        rotate(a = 90) bottom_piece();
    }
}

build();
