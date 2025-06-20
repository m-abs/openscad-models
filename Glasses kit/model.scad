include <../libraries/BOSL2/std.scad>

// Select part to make
mode = "Bottom container"; // [Bottom container, Top container]

// Wall thickness
wall = 2.5;

// Spray bottle height
sb_height = 63;

// Spray bottle diameter
sb_diameter = 13;

// Container height - without the wall thickness.
container_height = 101;
module make_model() {
  half_wall = wall / 2;

  container_width = sb_diameter * 4;
  container_length = sb_diameter;

  inner_length = container_height;
  inner_width = sb_diameter * 4;
  inner_height = sb_diameter + 0.5;

  inner_space_length = inner_length;
  inner_space_width = inner_width + 2 * wall;
  inner_space_height = inner_height + 2 * wall;

  lid_inner_length = container_height / 2;
  lid_inner_width = inner_space_width + -wall;
  lid_inner_height = inner_space_height + -wall;

  lid_length = lid_inner_length + wall;
  lid_width = inner_space_width;
  lid_height = inner_space_height;

  /**
     * Model a cuboid with rounded sides. Top and bottom are not rounded.
     */
  module make_bottom(height, length, width, anchor = CENTER) {
    // We want a fully rounded side.
    rounding = width / 2;

    cuboid([length, width, height], rounding=rounding, anchor=anchor, except=[TOP, BOTTOM], $fn=80) {
      children();
    }
  }

  module make_container(height, length, width, wall, anchor) {
    rounding = width / 2 + wall;

    rect_tube(h=height, isize=[length, width], wall=wall, rounding=rounding, anchor=anchor, $fn=80) {
      children();
    }
  }

  /**
     * Tube for the spray bottle to be in the container
     */
  module spray_bottle_tube() {
    hole_size = sb_diameter / 3.5; // Size of the hole in the tube

    diff() {
      // Make the tube for the spray bottle
      right(sb_diameter / 2 + half_wall) tube(
          ir=container_length / 2, h=sb_height, wall=half_wall, anchor=BOTTOM,
          teardrop=true, $fn=80
        ) {
          position(BOTTOM + RIGHT)
            tag("remove")
              cyl(sb_height, r=hole_size, anchor=BOTTOM);
        }
    }
  }

  /***
     * Make the container part
     */
  module make_bottom_container() {
    up(half_wall)
      make_container(container_height, container_width, container_length, half_wall, anchor=BOTTOM) {
        position(BOTTOM) {
          make_container(container_height / 2, container_width + wall, container_length + wall, half_wall, anchor=BOTTOM);
          position(LEFT)
            spray_bottle_tube();
        }
      }
    make_bottom(half_wall, container_width + 2 * wall, container_length + 2 * wall, anchor=BOTTOM);
  }

  module make_top_container() {
    up(half_wall)
      make_container(container_height / 2, container_width + wall, container_length + wall, half_wall, anchor=BOTTOM);

    make_bottom(half_wall, container_width + 2 * wall, container_length + 2 * wall, anchor=BOTTOM);
  }

  if (mode == "Bottom container") {
    make_bottom_container();
  } else if (mode == "Top container") {
    make_top_container();
  }
}

make_model();
