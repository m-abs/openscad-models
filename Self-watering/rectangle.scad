include <../libraries/BOSL2/std.scad>

width = 200;
length = 300;
height = 250;

inner_height = 50;

module model() {
  outer_wall = 4;
  inner_wall = 2.5;

  inner_width = max(width * 0.3, 30);
  inner_length = max(length * 0.3, 30);

  water_input_offset = 15;
  water_input_size = 30;
  water_hole_r = 2.25;
  module water_intake_hole(size) {
    xrot(90) cyl(h=size + 1, r=water_hole_r, $fn=16);
  }

  // Make the connection between the water and the soil.
  module water_holes_cutout() {
    // Space needed for the water intake holes
    // r*3 gives us diameter of the hole plus sensible padding.
    hole_size = (water_hole_r * 3);

    // Number of holes vertically
    num_vertical_holes = floor(inner_height / hole_size) - 1;

    // Number of holes horizontally width side.
    width_side_length = (inner_width - inner_wall * 2);
    num_width_side_holes = floor(width_side_length / hole_size) - 1;

    // Number of holes horizontally length side.
    long_side_length = (inner_length - inner_wall * 2);
    num_long_side_holes = floor(long_side_length / hole_size) - 1;

    for (i = [0:1:num_vertical_holes]) {
      up(i * hole_size + water_hole_r + 0.1) {
        // Make the holes in the width side
        left(num_width_side_holes * hole_size / 2) {
          num_holes = i % 2 == 0 ? num_width_side_holes : num_width_side_holes - 1;
          for (j = [0:1:num_holes]) {
            r = i % 2 == 0 ? j * hole_size : j * hole_size + hole_size / 2;
            right(r) water_intake_hole(inner_length);
          }
        }

        // Make the holes in the long side
        fwd(num_long_side_holes * hole_size / 2) zrot(90) {
            num_holes = i % 2 == 0 ? num_long_side_holes : num_long_side_holes - 1;
            for (j = [0:1:num_holes]) {
              r = i % 2 == 0 ? j * hole_size : j * hole_size + hole_size / 2;
              right(r) water_intake_hole(inner_width);
            }
          }
      }
    }
  }

  module water_intake() {
    up(outer_wall - 0.1) rect_tube(
        h=inner_height, size=[inner_width, inner_length], wall=inner_wall,
        rounding=inner_wall, anchor=BOTTOM
      ) {
        tag("remove") position(BOTTOM) water_holes_cutout();
      }
  }

  // Make the water input funnel
  module water_funnel() {
    water_input_height = height - inner_height - 30;

    up(water_input_offset) position(FRONT + TOP) back(outer_wall - inner_wall)
          cuboid(
            [water_input_size, water_input_size, water_input_height], rounding=inner_wall / 2,
            anchor=FRONT + TOP, edges="Z"
          ) {
            water_input_size_inner = water_input_size - inner_wall * 2;
            tag("remove") {
              cuboid(
                [water_input_size_inner, water_input_size_inner, water_input_height],
                rounding=inner_wall / 2, edges="Z"
              );
            }
          }
  }

  diff() {
    rect_tube(h=height, size=[width, length], wall=outer_wall, rounding=outer_wall, anchor=BOTTOM + LEFT + FRONT) {
      position(BOTTOM) {
        cuboid([width, length, outer_wall], rounding=outer_wall, anchor=BOTTOM, edges="Z");

        up(inner_height + outer_wall)
          rect_tube(
            h=inner_height, size2=[width, length], size1=[inner_width, inner_length],
            wall=outer_wall, rounding=outer_wall, anchor=BOTTOM
          );

        water_intake();
      }

      water_funnel();
    }
  }
}

model();
