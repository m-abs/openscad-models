include <../libraries/BOSL2/std.scad>
include <../libraries/BOSL2/threading.scad>

diameter = 200;
height = 260;

inner_height = 40;

mode = 1; // [1:Inner,2:Screw]

module model() {
  outer_wall = 4;
  inner_wall = 2.5;

  water_hole_r = 5;
  water_input_offset = 30;
  water_input_size = 30;

  inner_diameter = max(diameter * 0.3, 30);
  module water_intake_hole() {
    xrot(90) cyl(h=inner_diameter, r=water_hole_r, $fn=4);
  }

  // Make the connection between the water and the soil.
  module water_hole() {
    // Space needed for the water intake holes
    // r*3 gives us diameter of the hole plus sensible padding.
    hole_size = (water_hole_r * 3);

    // Number of holes vertically
    num_vertical_holes = floor(inner_height / hole_size);

    hole_angle = 45;
    for (i = [0:1:360 / hole_angle - 1]) {
      for (j = [0:1:num_vertical_holes]) {
        z_rot = j % 2 == 0 ? i * hole_angle : i * hole_angle + hole_angle / 2;
        up(j * hole_size) zrot(z_rot) water_intake_hole();
      }
    }
  }

  if (mode == 1) {
    diff() {
      up(inner_height - 0.1)
        tube(h=inner_height / 4, od=inner_diameter, wall=inner_wall, $fn=360, anchor=BOTTOM) {
          position(TOP) tube(h=inner_wall, id=inner_diameter, wall=15, $fn=360, anchor=TOP);
          up(inner_height / 8) position(TOP) color("green") trapezoidal_threaded_rod(
                  d=inner_diameter, l=inner_height / 8, pitch=2, anchor=TOP, $fn=360
                ) {
                  tag("remove") position(TOP) up(0.5)
                        cyl(h=inner_height / 8 + 1, d=inner_diameter - 2 * inner_wall, anchor=TOP);
                }
        }
      tube(h=inner_height, od=inner_diameter, wall=inner_wall, $fn=360, anchor=BOTTOM) {
        position(BOTTOM) tag("remove") water_hole();
      }
    }
  } else if (mode == 2) {
    diff() {
      cyl(h=inner_height / 8, d=inner_diameter + inner_wall, anchor=BOTTOM, $fn=16) {
        tag("remove") trapezoidal_threaded_rod(d=inner_diameter, l=inner_height / 8, pitch=2, $fn=360);
      }
    }
  }
}

model();
