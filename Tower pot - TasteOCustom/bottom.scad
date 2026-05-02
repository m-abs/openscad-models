include <../libraries/BOSL2/std.scad>;

module water_way() {
  cyl(h=180, r=10, $fn=64);
}

difference() {
  down(99) cyl(h=10, r=90, $fn=360);
  down(105) {
    cyl(h=10, r=10, $fn=360);
  }
  down(95) cyl(h=10, r=80, $fn=360);

  import("Tower pot.stl");
  down(111) {
    xrot(90) {
      for (i = [0:3]) {
        yrot(i * (360 / 8)) water_way();
      }
    }
  }
}
