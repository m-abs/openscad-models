include <../libraries/BOSL2/std.scad>

diff() tube(h = 270, od1 = 180, od2 = 245, wall = 25, anchor = BOTTOM)
{
    tag("remove") position(BOTTOM) cyl(h = 80, d = 200, anchor = BOTTOM);
}