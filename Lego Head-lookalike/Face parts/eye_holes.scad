include <../libraries/BOSL2/std.scad>;

difference() {
  down(3.6) back(2.5) cyl(h=1.5, r=5, center=true);
  import("eye2_flat.stl", center=true);
}
