include <../libraries/BOSL2/std.scad>

module make()
{
    support_diameter = 52;
    height = 148 / 2;

    diff()
    {
        tube(h = height, od = support_diameter, wall = 2, anchor = BOTTOM, $fn = 360)
        {
            position(BOTTOM) tag("remove") cyl(h = 10, d = support_diameter + 0.01, anchor = BOTTOM, $fn = 6);
        }
    }
}

make();