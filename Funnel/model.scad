include <../libraries/BOSL2/std.scad>

mouth_diameter = 200;
mouth_height = 5;
stem_height = 150;
spout_height = 100;
spout_diameter_top = 50;
spout_diameter_bottom = 35;

wall_thickness = 2;

if (mouth_height > 0)
{
    tube(h = mouth_height, od = mouth_diameter, wall = wall_thickness, anchor = BOTTOM, $fn = 100);
}

up(mouth_height) tube(h = stem_height, od1 = mouth_diameter, od2 = spout_diameter_top, wall = wall_thickness,
                      anchor = BOTTOM, $fn = 100)
{
    up(stem_height)
    {
        position(BOTTOM) tube(h = spout_height, od1 = spout_diameter_top, od2 = spout_diameter_bottom,
                              wall = wall_thickness, anchor = BOTTOM, $fn = 100);
    }
}