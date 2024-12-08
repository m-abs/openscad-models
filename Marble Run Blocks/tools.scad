include <../libraries/BOSL/constants.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/transforms.scad>

tunnel_width = 21;

support_single_filename = "MarbleRunBlocks-SupportSimple.stl";
support_double_filename = "MarbleRunBlocks-SupportDouble.stl";
grid2by2_filename = "MarbleRunBlocks-Grid2x2.stl";

module marbleTunnel(length = 42)
{
    tunnel_circle_radius = 9.5;
    tunnel_edge = 2.039;

    down(1) union()
    {
        cube([ tunnel_edge, length, tunnel_width ], center = true);
        cube([ tunnel_width, length, tunnel_edge ], center = true);

        for (i = [ -1, 1 ])
        {
            up((tunnel_width - tunnel_circle_radius * 2) / 2 * i)
            {
                left((tunnel_width - tunnel_circle_radius * 2) / 2) xrot(-90)
                    cylinder(r = tunnel_circle_radius, h = length, center = true);
                right((tunnel_width - tunnel_circle_radius * 2) / 2) xrot(-90)
                    cylinder(r = tunnel_circle_radius, h = length, center = true);
            }
        }
    }
}