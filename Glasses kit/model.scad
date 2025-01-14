include <../libraries/BOSL2/std.scad>

wall_thickness = 2;

length = 86;
width = 54;
height = 12.5;

outer_length = length + 2 * wall_thickness;
outer_width = width + 2 * wall_thickness;
outer_height = height + 2 * wall_thickness;

rounding = outer_height / 2;

diff()
{
    cuboid([ outer_length, outer_width, outer_height ], rounding = rounding, except = [ LEFT, RIGHT ], anchor = BOTTOM)
    {

        tag("remove") position(CENTER)
#cuboid([ outer_length, outer_width, height ], rounding = height / 2, except = [ LEFT, RIGHT ]);
    }
}