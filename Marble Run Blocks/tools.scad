include <../libraries/BOSL2/std.scad>

// Block sizes.

// A full block is 40x40x40mm + 2mm on top for the pegs.
block_width = 40;
block_height = 40;
pegs_height = 2;
peg_socket_height = 4; // From base.

half_block_height = block_height / 2;

corner_height = 3;

tunnel_width = 20;

end_bottom_plate_width = 25;
end_bottom_plate_single_length = 38;
end_bottom_plate_double_length = end_bottom_plate_single_length * 2;
end_bottom_plate_thickness = 1;

support_single_filename = "MarbleRunBlocks-SupportSimple.stl";
support_double_filename = "MarbleRunBlocks-SupportDouble.stl";
cattle_support_single_filename = "MarbleRunBlocks-CastleSupportSimple.stl";
cattle_support_double_filename = "MarbleRunBlocks-CastleSupportDouble.stl";
end_block_filename = "MarbleRunBlocks-End.stl";
start_block_filename = "MarbleRunBlocks-Start.stl";
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