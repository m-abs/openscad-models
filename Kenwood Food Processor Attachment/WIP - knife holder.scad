include <../libraries/dotSCAD/src/box_extrude.scad>

length = 150;
width = 87;
height = 20;
shell_thickness = 2.5;

module loadSVG()
{
    $fn = 360;
    translate([ -185.1, 33, 0 ])
    {
        import(file = "Kenwood s knife - page 2.svg", center = true);
    }
}

box_extrude(height = height, shell_thickness = shell_thickness, bottom_thickness = shell_thickness)
{
    union()
    {
        loadSVG();
        rotate(180) loadSVG();
    }
}