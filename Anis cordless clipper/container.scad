include <../libraries/BOSL2/std.scad>;

mode = "container"; // ["container", "lid"]
module model() {
  wall = 1.5;

  // Sizes are all inner dimensions for the container.
  comb_width = 48.9;
  machine_thickness = 48;
  machine_length = 190;
  machine_width = 60;

  comb_container_width = comb_width + 0.25;
  container_width = comb_container_width + machine_thickness;
  container_length = 220;
  container_height = 86;

  comb_max_height = 59.25;

  splitter_thickness = 1.25;
  splitter_offset = 13.25 + wall + splitter_thickness + 0.15;

  if (mode == "container") {
    rect_tube(h=container_height, isize=[comb_container_width, container_length], wall=wall, rounding=wall / 2, irounding=wall, anchor=BOTTOM, $fn=180) {
      position(LEFT + BOTTOM) right(splitter_offset) cuboid(size=[splitter_thickness, container_length, comb_max_height], anchor=RIGHT + BOTTOM);
      position(RIGHT + BOTTOM) left(splitter_offset) cuboid(size=[splitter_thickness, container_length, comb_max_height], anchor=LEFT + BOTTOM);
      position(BOTTOM) cuboid(size=[comb_container_width, container_length, wall], anchor=BOTTOM);
      position(LEFT + BOTTOM) right(wall) rect_tube(h=container_height, isize=[machine_thickness, container_length], wall=wall, rounding=wall / 2, irounding=wall, anchor=RIGHT + BOTTOM, $fn=180) {
            position(BOTTOM) cuboid(size=[machine_thickness, container_length, container_height - machine_width - 5], anchor=BOTTOM);
          }
    }
  } else if (mode == "lid") {
    lid_height = 20;
    lid_width = container_width + wall * 3 + 0.15;
    lid_length = container_length + wall * 2 + 0.15;

    rect_tube(h=lid_height, isize=[lid_width, lid_length], wall=wall, rounding=wall / 2, anchor=BOTTOM, $fn=180) {
      position(BOTTOM) cuboid(size=[lid_width, lid_length, wall], anchor=BOTTOM);
    }
  }
}

model();
