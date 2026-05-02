include <../libraries/BOSL2/std.scad>;

// Make finger hole?
finger_hole = true;

// Make finger hole closed (with a small cap)?
closed_finger_hole = true;

diff() {
  top_radius = 179 / 2;
  bottom_radius = top_radius - 3;
  wall = 2.5;
  height = 20;

  finger_hole_radius = 15 + wall;
  finger_hole_height = height - wall * 3;

  finger_hole_offset = top_radius - bottom_radius + wall + finger_hole_radius;

  tube(h=height, or1=bottom_radius, or2=top_radius, wall=wall, $fn=180) {
    position(TOP) cyl(h=wall, r=top_radius - 1, $fn=180, anchor=TOP);
    tag("remove") {
      // Middle hole
      position(TOP) cyl(h=wall, r=25, anchor=TOP);

      // Finger hole
      if (finger_hole)
        right(top_radius - bottom_radius + wall + finger_hole_radius)
          position(LEFT + TOP) cyl(h=finger_hole_height, r=finger_hole_radius - wall, anchor=TOP);

      // Cut in half
      right(top_radius / 2) position(BOTTOM + CENTER) cuboid(size=[top_radius, top_radius * 2, height], anchor=BOTTOM);
    }

    // Finger hole
    if (finger_hole && closed_finger_hole)
      right(top_radius - bottom_radius + wall + finger_hole_radius)
        position(LEFT + TOP) down(wall) cyl(h=finger_hole_height, r=finger_hole_radius, anchor=TOP);
  }
}
