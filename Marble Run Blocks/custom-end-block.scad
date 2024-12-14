include <../libraries/BOSL2/std.scad>
include <./tools.scad>

// Build mode
mode = 1; // [1:Single,2:Double,3:End 4 by 4]

// Add a bottom to the block
add_bottom = true;

if (mode == 1)
{
    difference()
    {
        // TODO: Castle support can't be rendered in OpenSCAD.
        filename = mode == 1 ? support_single_filename : cattle_support_single_filename;
        import(filename);

        union()
        {
            up(tunnel_width)
            {
                marbleTunnel();
                zrot(90) marbleTunnel();
            }
        }
    }

    if (add_bottom)
    {
        up(end_bottom_plate_up)
        {
            for (i = [ 0, 1 ])
            {
                zrot(90 * i)
                    cube([ end_bottom_plate_width, end_bottom_plate_single_length, end_bottom_plate_thickness ],
                         anchor = BOTTOM);
            }
        }
    }
}
else if (mode == 2)
{
    difference()
    {
        // TODO: Castle support can't be rendered in OpenSCAD.
        filename = mode == 2 ? support_double_filename : cattle_support_double_filename;
        import(filename);

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
    if (add_bottom)
    {
        up(end_bottom_plate_up)
        {
            for (i = [ -1, 1 ])
            {
                left(20 * i)
                    cube([ end_bottom_plate_width, end_bottom_plate_single_length, end_bottom_plate_thickness ],
                         anchor = BOTTOM);
            }

            zrot(90) cube([ end_bottom_plate_width, end_bottom_plate_double_length, end_bottom_plate_thickness ],
                          anchor = BOTTOM);
        }
    }
}
else if (mode == 3)
{
    filename = support_double_filename;
    difference()
    {
        union()
        {
            {
                for (i = [ -1, 1 ])
                {
                    back(20 * i) import(filename);
                }
            }
        }

        up(tunnel_width)
        {

            for (i = [ -1, 1 ])
            {
                left(20 * i) marbleTunnel(81);
                fwd(20 * i) zrot(90) marbleTunnel(81);
            }
        }
        cube([ 60, 60, 40 ], anchor = BOTTOM);
    }

    if (add_bottom)
    {
        up(end_bottom_plate_up)
        {
            for (j = [ 0, 1 ])
            {
                zrot(90 * j)
                {
                    for (i = [ -1, 1 ])
                    {
                        left(20 * i) cube([ end_bottom_plate_width, 75, end_bottom_plate_thickness ], anchor = BOTTOM);
                    }

                    cube([ 4, 75, end_bottom_plate_thickness ], anchor = BOTTOM);
                }
            }
        }
    }
}
else
{
    echo("Invalid mode");
}