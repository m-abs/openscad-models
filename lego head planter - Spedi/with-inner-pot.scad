include <../libraries/BOSL2/std.scad>;

import("legoheadplanter_easyprint-v14.stl");
diff() {
  wall = 2.5;
  full_height = 135;

  top_offset = 50;
  top_diameter = 141;
  bottom_diameter = 75;
  pot_height = full_height - top_offset;

  botton_height = 20;

  up(2.9) {
    drain_r1 = bottom_diameter / 2 / 2;
    drain_r2 = (bottom_diameter + 20) / 2;
    drain_h = 30;
    drain_hole_r = 1.75;

    tube(h=drain_h, or1=drain_r1, or2=drain_r2, wall=wall, anchor=BOTTOM, $fn=360) {
      position(TOP) tube(h=pot_height - drain_h, or1=drain_r2, or2=top_diameter / 2, wall=wall, anchor=BOTTOM, $fn=360) {
          tag("remove")for (j = [LEFT, RIGHT, FRONT, BACK]) {
            position(j + TOP) cyl(h=10, r=drain_hole_r + wall, anchor=TOP);
          }
        }
      tag("remove")for (u = [0:(drain_hole_r + wall * 2):(drain_h - 1)])
        up(u)for (i = [0:drain_h:330]) {
          position(BOTTOM) zrot(i) cyl(h=drain_r2 * 2 + wall * 2, r=drain_hole_r, orient=LEFT);
        }
    }
  }
}
