include <../libraries/BOSL2/std.scad>

height = 50.0;
width = 250;
length = 112;

module make() {
  wall_thickness = 1.5;

  diff() {
    cuboid([width, length, height], anchor=BOTTOM, rounding=wall_thickness, except=BOTTOM, $fn=100) {
      tag("remove") position(TOP) up(0.01)
            cuboid(
              [width - wall_thickness * 2, length - wall_thickness * 2, height - wall_thickness],
              anchor=TOP, rounding=wall_thickness * 1.5, except=TOP, $fn=100
            );
    }
  }
}

make();
