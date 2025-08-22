include <../libraries/BOSL/constants.scad>
include <./constants.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/threading.scad>
use <../libraries/BOSL/transforms.scad>
use <./shared.scad>

module pusher_lid() {
  difference() {
    r = (pusher_top_width + pusher_wall) / 2;

    // make a small rounded bottom.
    union() {
      up(pusher_lid_height) zscale(5 / r) staggered_sphere(r=r, align=V_TOP, $fn=240);
      cyl(l=pusher_lid_height, r=r, align=V_TOP, $fn=48);
    }

    up(1) pusher_lid_thread();
    down(0.1) cyl(d=pusher_top_width + 1.5, h=1.11, align=V_TOP, $fn=160);
  }
}

pusher_lid();
