include <../libraries/BOSL2/std.scad>;

mode = "container"; // ["container", "lid"]
module model() {
  wall = 2;

  // Sizes are all inner dimensions for the container.
  comb_width = 49;
  machine_thickness = 49;
  machine_length = 190;
  machine_width = 60;

  comb_compartment_width = comb_width + 1.5;

  small_padding = 0.25;
  splitter_thickness = 1.25;

  // Combs sizes
  comb_offset_0 = 12.2;
  comb_offset_1 = 12.2 + comb_offset_0 + splitter_thickness + small_padding;
  comb_offset_2 = 17.20 + comb_offset_1 + splitter_thickness + small_padding;
  comb_offset_3 = 19.85 + comb_offset_2 + splitter_thickness + small_padding;
  comb_offset_4 = 22.52 + comb_offset_3 + splitter_thickness + small_padding;
  comb_offset_5 = 25.72 + comb_offset_4 + splitter_thickness + small_padding;
  comb_offset_6 = 26.7 + comb_offset_5 + splitter_thickness + small_padding;
  comb_offset_7 = 28.1 + comb_offset_6 + splitter_thickness + small_padding;
  comb_offset_8 = 28.7 + comb_offset_7 + splitter_thickness + small_padding;

  // Length measured with the top being pressed down, this makes the combs slightly longer.
  comb_length_0 = 56.1;
  comb_length_1 = 56.7;
  comb_length_2 = 68;
  comb_length_3 = 71.7;
  comb_length_4 = 74.7;
  comb_length_5 = 77.6;
  comb_length_6 = 81.0;
  comb_length_7 = 84.2;
  comb_length_8 = 88.0;

  comb_compartments = [
    [comb_offset_0, comb_length_0],
    [comb_offset_1, comb_length_1],
    [comb_offset_2, comb_length_2],
    [comb_offset_3, comb_length_3],
    [comb_offset_4, comb_length_4],
    [comb_offset_5, comb_length_5],
    [comb_offset_6, comb_length_6],
    [comb_offset_7, comb_length_7],
    [comb_offset_8, comb_length_8],
  ];

  container_width = comb_compartment_width + machine_thickness + wall;
  container_length = comb_offset_8;
  container_height = comb_length_8 + wall * 2;

  if (mode == "container") {
    rect_tube(h=container_height + wall, isize=[container_width, container_length], wall=wall, rounding=wall, irounding=wall, anchor=BOTTOM, $fn=60) {
      position(BOTTOM) {
        position(LEFT) {
          splitter_height = container_height - 30;
          splitter_width = comb_compartment_width + wall;

          back(wall)for (item = comb_compartments) {
            comb_offset = item[0];
            comb_length = item[1];

            // Raise the comb so they are at about the same height.
            comb_lift = container_height - comb_length - wall;
            position(FRONT) back(comb_offset) right(wall) {
                  cuboid(size=[splitter_width, splitter_thickness, splitter_height], anchor=LEFT + BOTTOM + FRONT) {
                    if (comb_lift > 0) {
                      position(BOTTOM + FRONT) cuboid(size=[splitter_width, comb_offset, comb_lift], anchor=BACK + BOTTOM);
                    }
                  }
                }
          }
        }

        position(RIGHT) {
          // Middle wall
          left(comb_compartment_width + wall) cuboid(size=[wall, container_length, container_height], anchor=LEFT + BOTTOM);

          // Raised floor for the machine compartment.
          left(wall) cuboid(size=[machine_thickness, container_length, container_height - machine_width - 5], anchor=RIGHT + BOTTOM);
        }

        // Floor
        //cuboid(size=[container_width, container_length, wall], anchor=BOTTOM);
      }
    }
  } else if (mode == "lid") {
    lid_height = 15;
    lid_width = container_width + wall * 3 + small_padding;
    lid_length = container_length + wall * 2 + small_padding;

    rect_tube(h=lid_height, isize=[lid_width, lid_length], wall=wall, rounding=wall, anchor=BOTTOM, $fn=60) {
      position(BOTTOM) cuboid(size=[lid_width, lid_length, wall], anchor=BOTTOM);
    }
  }
}

model();
