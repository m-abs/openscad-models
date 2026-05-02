include <../libraries/BOSL2/std.scad>;

difference() {
  import("Tower pot - bottom.stl");
  cyl(h=200, r=10);
  down(100) xrot(90) {
      cyl(h=200, r=6, $fn=4);
      yrot(90) cyl(h=200, r=6, $fn=4);
    }
}
