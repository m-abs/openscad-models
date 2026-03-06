include <../../libraries/BOSL2/std.scad>

// bottom ir = 75
// top or = 73

rows = 1;
cols = 3;
mode = "bottom"; // ["bottom", "middle", "top"]

module model() {
  wall = 1.8;

  // Weck 80mm glass dimensions.
  glass_diameter = 80;

  // Spacing between glasses including some extra space.
  spacing = glass_diameter + 5 * 2 + 1;

  // Cut out size for the bottom, inner radius.
  bottom_ir = 76.8 / 2;

  // Outer radius for part that goes into the top of the glass.
  top_or = 74 / 2;

  // Lid inner outer radius.
  top_inner_lid_or = 65 / 2;

  holder_height = 7.5;

  fn = 60;

  // Calculate plate size in one dimension for "middle" mode.
  function calc_plate_size_middle(n) =
    n == 1 ? (
        (bottom_ir + wall) * 2
      )
    : (
      spacing * (n - 1)
    );

  // Calculate plate size in one dimension based on mode.
  function calc_plate_size(n) =
    mode == "middle" ?
      calc_plate_size_middle(n)
    : (
      spacing * n - 1
    );

  // Calculate position offset in one dimension for "middle" mode.
  function calc_pos_offset_middle(n, total) =
    total == 1 ? (
        spacing / 2 - (spacing - (bottom_ir + wall) * 2) / 2
      )
    : (
      spacing * n
    );

  // Calculate position offset in one dimension based on mode.
  function calc_pos_offset(n, total) = mode == "middle" ? calc_pos_offset_middle(n, total) : (spacing * (n + 0.5));

  // The plate connecting the glas holders.
  module plate(plate_width, plate_depth, anchor) {
    plate_thickness = mode == "middle" ? wall + holder_height : wall;

    cuboid([plate_width, plate_depth, plate_thickness], anchor=anchor) {
      children();
    }
  }

  // The part that goes into the top of the glass.
  module top_holder() {
    position(BOTTOM + LEFT + FWD) {
      cyl(h=wall + holder_height, r=top_or, anchor=TOP, $fn=fn) {
        position(BOTTOM) cyl(h=holder_height, r=top_inner_lid_or, anchor=TOP, $fn=fn) {
            if (mode == "middle") {
              position(BOTTOM)
                tag("remove")
                  cyl(h=(holder_height + wall) * 2 + 0.02 + wall, r=top_inner_lid_or - wall, anchor=BOTTOM, $fn=fn);
            }
          }
      }
    }
  }

  // Holder for the bottom of the glass.
  module bottom_holder() {
    pos = mode == "middle" ? BOTTOM + LEFT + FWD : TOP + LEFT + FWD;

    position(pos) {
      cyl(h=wall + holder_height, r=bottom_ir + wall, anchor=BOTTOM, $fn=fn) {
        position(TOP)
          tag("remove")
            cyl(h=holder_height, r=bottom_ir, anchor=TOP, $fn=fn, rounding1=wall);
      }
    }
  }

  // Model for a single glass (rows = 1 and cols = 1).
  module single_glass() {
    plate_width = mode == "middle" ? spacing / 2 : spacing;
    plate_depth = plate_width;

    plate(plate_width, plate_depth, anchor=BOTTOM) {
      right(plate_width / 2) back(plate_depth / 2) {
          if (mode == "bottom" || mode == "middle") {
            bottom_holder();
          }

          if (mode == "middle" || mode == "top") {
            top_holder();
          }
        }
    }
  }

  // Model for multiple glasses (rows > 1 or cols > 1).
  module multi_glasses() {
    plate_width = calc_plate_size(cols);
    plate_depth = calc_plate_size(rows);

    plate(plate_width, plate_depth, anchor=BOTTOM + LEFT) {
      for (r = [0:rows - 1]) {
        back(calc_pos_offset(r, rows)) {
          for (c = [0:cols - 1]) {
            right(calc_pos_offset(c, cols)) {
              {
                if (mode == "bottom" || mode == "middle") {
                  bottom_holder();
                }

                if (mode == "middle" || mode == "top") {
                  top_holder();
                }
              }
            }
          }
        }
      }
    }
  }
  diff() {
    if (rows == 1 && cols == 1) {
      single_glass();
    } else {
      multi_glasses();
    }
  }
}

model();
