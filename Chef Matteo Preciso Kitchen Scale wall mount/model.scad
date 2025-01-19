include <../libraries/BOSL2/std.scad>

make_screw_hole = true;

module screw_hole()
{
    cyl(h = 4.5, r1 = 5, r2 = 0, anchor = BOTTOM, $fn = 60)
    {
        cyl(h = 10, r = 4.5 / 2, anchor = BOTTOM);
    }
}

module make()
{
    wall_thickness = make_screw_hole ? 4 : 2.5;
    inner_width = 133.5;
    inner_length = 190;
    inner_height = 30;

    front_length = 41;
    front_height = 16;

    wedge_width = inner_width + 2 * wall_thickness;
    wedge_length = inner_length - front_length;
    wedge_height = inner_height + wall_thickness;

    diff()
    {
        rect_tube(h = inner_length, isize = [ inner_height, inner_width ], wall = wall_thickness, orient = LEFT,
                  anchor = LEFT)
        {
            position(BOTTOM) cuboid([ front_length, inner_width, front_height ], anchor = LEFT + BOTTOM, orient = LEFT,
                                    chamfer = 1, edges = RIGHT + BOTTOM);

            // Make the wedge cutout
            position(RIGHT) up(front_length / 2) left(inner_height + wall_thickness) tag("remove")
                wedge([ wedge_width, wedge_length, wedge_height ], anchor = TOP, orient = LEFT, spin = 90);

            position(RIGHT + TOP) left(wall_thickness / 2) tag("remove")
                cuboid([ wall_thickness, inner_width, wedge_length ], anchor = TOP);

            if (make_screw_hole)
            {
                // Make screw holes
                tag("remove")
                {
                    y_row = -90;
                    up_val = -wall_thickness;

                    wall_offset = 25;
                    top_offset = 40;
                    left(up_val)
                    {
                        position(LEFT) yrot(y_row) #screw_hole();

                        down(top_offset)
                        {
                            position(BACK + LEFT + TOP) fwd(wall_offset) yrot(y_row) #screw_hole();
                            position(FWD + LEFT + TOP) back(wall_offset) yrot(y_row) #screw_hole();
                        }
                    }
                }
            }
        };
    }
}

make();