length = 240;
width = 50;
thickness = 10;

pole_diameter = 16;
pole_length = 80;

module pole()
{
    translate([ 0, 0, pole_length / 2 + thickness / 2 ])
    {
        cylinder(h = pole_length - 15, r = pole_diameter / 2, center = true, $fn = 100);
        translate([ 0, 0, -(pole_length - 15) / 2 ])
        {
            cylinder(h = 25, r1 = width / 2, r2 = pole_diameter / 2, center = true, $fn = 100);
        }
    }
}

module bottom_piece()
{
    p_length = length - width / 2;
    translate([ -p_length / 2, 0, 0 ]) cylinder(h = thickness, r = width / 2, center = true, $fn = 100);
    cube([ width, p_length, thickness ], center = true);
    translate([ p_length / 2, 0, 0 ]) cylinder(h = thickness, r = width / 2, center = true, $fn = 100);

    pole_offset = length / 2 - pole_diameter;
    translate([ -pole_offset, 0, 0 ]) rotate([ 0, 10, 0 ]) pole();
    translate([ pole_offset, 0, 0 ]) rotate([ 0, -10, 0 ]) pole();
}

module bottom()
{
    translate([ 0, 0, thickness / 2 ])
    {
        bottom_piece();
        rotate(a = 90) bottom_piece();
    }
}

rotate(a = 45) 
bottom();