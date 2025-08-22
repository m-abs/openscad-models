include <../../libraries/BOSL2/std.scad>

diff() {
  z_length = 15.5;
  wall = 2.6;

  x_clamp = 7.8;
  y_clamp = 46.2;
  clamp_opening = 35.8;

  x_holder = 33.6;
  y_holder = 33.2;

  x_arm = 60;
  y_arm = 5.75;

  rect_tube(h=z_length, size=[x_clamp, y_clamp], wall=wall, rounding=wall, irounding=0, anchor=BOTTOM, $fn=80) {
    tag("remove")
      right(wall / 2)
        position(BOTTOM + LEFT)
          cuboid(size=[wall, clamp_opening, z_length], anchor=BOTTOM);

    position(BOTTOM + RIGHT)
      right(y_holder / 2 - wall + 0.19)
        cuboid(size=[x_holder, y_holder, z_length], rounding=wall, except_edges=[LEFT, TOP, BOTTOM], anchor=BOTTOM, $fn=80) {
          position(BOTTOM + LEFT) down(0.1) tag("remove") cuboid(size=[x_holder - wall, y_holder - wall * 2, z_length + 0.2], anchor=LEFT + BOTTOM, $fn=80);

          position(BOTTOM + RIGHT + BACK)
            right(x_arm)
              fwd(y_arm * 2)
                cuboid(size=[x_arm, y_arm, z_length], rounding=wall, except_edges=[LEFT, FRONT, BACK], anchor=BOTTOM + RIGHT, $fn=80) {
                  fwd(y_arm / 2) tag("remove") cyl(h=y_arm, r=6.4 / 2, orient=BACK, chamfer=-1, anchor=BOTTOM + CENTER);
                }
        }
  }
}
