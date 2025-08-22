include <../libraries/BOSL2/std.scad>

tube(h=100, id=145, wall=4, anchor=BOTTOM, $fn=16) {
  position(BOTTOM) cyl(h=4, d=145 + 4 * 2, rounding=2);
  up(15) position(TOP) tube(h=30, id1=145, id2=160, wall=4, $fn=16);
}
