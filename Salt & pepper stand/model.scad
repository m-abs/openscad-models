include <../libraries/BOSL2/std.scad>

module make() {
  diameter = 65;
  wall_thickness = 1.5;
  height = 7.5;
  length = 2 * (diameter + wall_thickness) + wall_thickness;
  width = diameter + wall_thickness * 2;

  hole_height = height - wall_thickness;

  rounding = width / 2;

  diff() {
    cuboid([width, length, height], rounding=rounding, anchor=CENTER, except=[TOP, BOTTOM], $fn=360) {
      tag("remove")for (i = [1, -1]) {
        position(TOP) up(0.01) back((diameter + wall_thickness) / 2 * i) cylinder(
                d=diameter, h=hole_height + 0.01,
                anchor=TOP, $fn=360
              );
      }
    }
  }
}

make();
