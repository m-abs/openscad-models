include <../libraries/BOSL/constants.scad>
include <./tools.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/transforms.scad>

$fn = 180;

mode = 1; // [1:Single,2:Double]

if (mode == 1)
{
    difference()
    {
        import(support_single_filename);

        union()
        {
            up(tunnel_width)
            {
                marbleTunnel();
                zrot(90) marbleTunnel();
            }
        }
    }
}
else if (mode == 2)
{
    difference()
    {
        import(support_double_filename);

        union()
        {
            up(tunnel_width)
            {

                for (i = [ -1, 1 ])
                {
                    xmove(20 * i)
                    {
                        marbleTunnel(80);
                        zrot(90) marbleTunnel();
                    }
                }
            }
            cube([ 20, 20, 40 ], center = true);
        }
    }
}
else
{
    echo("Invalid mode");
}