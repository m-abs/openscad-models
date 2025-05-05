include <../libraries/BOSL2/std.scad>

outer_diameter = 15.95;
wall_thickness = 3;
height = 130;
connecter_height = 30;

mode = "connector"; // [top,connector]

module model()
{
    outer_height = height;
    inner_height = mode == "top" ? height - connecter_height : height;
    offset = connecter_height;

    echo("build", outer_height, inner_height);

    tube(h = outer_height, od = outer_diameter, wall = wall_thickness, anchor = BOTTOM, $fn = 160);

    up(offset) cyl(h = inner_height, d = outer_diameter - wall_thickness * 2, anchor = BOTTOM, $fn = 160);
}

model();