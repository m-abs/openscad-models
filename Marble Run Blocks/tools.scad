include <../libraries/BOSL2/std.scad>

EDGES_TOP_AND_SIDES = [ [ 0, 0, 1, 1 ], [ 0, 0, 1, 1 ], [ 1, 1, 1, 1 ] ];

// Block sizes.

// A full block is 40x40x40mm + 2mm on top for the pegs.
block_width = 40;
block_height = 40;

half_block_height = block_height / 2;
double_block_height = block_height * 2;

// Peg sizes.
peg_width = 3.4;
peg_height = 2;
peg_offset_side = 2.8;                                        // From side.
peg_offset = (block_width - peg_width) / 2 - peg_offset_side; // From center.

// Peg socket sizes.
peg_socket_width = 4;
peg_socket_height = 4;                                                              // From base.
peg_socket_offset_side = 2.5;                                                       // From size.
peg_socket_offset = (block_width - peg_socket_height) / 2 - peg_socket_offset_side; // From center.

middle_cutout_width = 20;
middle_cutout_height = 8; // From base.

corner_height = 3;

// Tunnel sizes.
tunnel_width = 20;
tunnel_circle_radius = 9.5;

// support sizes
support_column_width = 10;
support_inner_corner_cutout = 3.5;

// End block sizes.
end_bottom_plate_width = 25;
end_bottom_plate_single_length = 38;
end_bottom_plate_double_length = end_bottom_plate_single_length * 2;
end_bottom_plate_thickness = 1;

// File names
support_single_filename = "MarbleRunBlocks-SupportSimple.stl";
support_double_filename = "MarbleRunBlocks-SupportDouble.stl";
castle_support_single_filename = "MarbleRunBlocks-CastleSupportSimple.stl";
castle_support_double_filename = "MarbleRunBlocks-CastleSupportDouble.stl";
end_block_filename = "MarbleRunBlocks-End.stl";
grid2by2_filename = "MarbleRunBlocks-Grid2x2.stl";

module marbleTunnel(length = 42)
{
    tunnel_circle_radius = 9.5;
    tunnel_straight_middle = tunnel_width - tunnel_circle_radius * 2;

    for (i = [ 0, 1 ])
    {
        yrot(90 * i) cube([ tunnel_straight_middle, length, tunnel_width ], anchor = CENTER);
    }

    for (i = [ -1, 1 ])
    {
        up((tunnel_width - tunnel_circle_radius * 2) / 2 * i)
        {
            left((tunnel_width - tunnel_circle_radius * 2) / 2)
                cylinder(r = tunnel_circle_radius, h = length, anchor = CENTER, orient = FORWARD, $fn = 80);
            right((tunnel_width - tunnel_circle_radius * 2) / 2)
                cylinder(r = tunnel_circle_radius, h = length, anchor = CENTER, orient = FORWARD, $fn = 80);
        }
    }
}

// Module: keep()
// Synopsis: Wrapper for tag("keep")
module keep()
{
    tag("keep") children();
}

// Module: remove()
// Synopsis: Wrapper for tag("remove")
module remove()
{
    tag("remove") children();
}