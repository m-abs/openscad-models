include <../libraries/BOSL2/std.scad>

rect_tube(size = [ 110, 250 ], wall = 2, rounding = 5, h = 50)
{
    position(BOTTOM) cuboid(size = [ 110, 250, 1 ], rounding = 5, except = [ TOP, BOTTOM ], anchor = BOTTOM);
};