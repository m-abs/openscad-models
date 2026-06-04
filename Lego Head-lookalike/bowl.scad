include <../libraries/BOSL2/std.scad>;

tube(h=30, od1=124, od2=172, wall=2.5, $fn=360, anchor=BOTTOM) {
  position(BOTTOM) cyl(h=2.5, d=124, anchor=BOTTOM, $fn=360);
}
