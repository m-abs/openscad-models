include <../libraries/BOSL2/std.scad>;

fn_factor = 16; // [16-360]
module model() {
  inner_fn_factor = 60;

  // Measurements taken from https://www.printables.com/model/177412-lego-head-planter-easier-print
  top_peg_height = 11;
  top_peg_diameter = 80;

  // Original lego head pot is 135 mm tail and 11 mm top height, use that to calculate face hole offsets.
  original_model_height = 135;
  face_height = original_model_height - top_peg_height;

  face_hole_diameter = 3;
  face_hole_depth = 8;

  wall = 3;

  face_diameter = 131;

  mount_hole_z_offset = 38.5;
  eye_holes_z_offset = 70;
  eyebrow_holes_z_offset = 96;

  face_rounding = 21;

  module single_face_hole() {
    tag("keep")
      right(face_diameter / 2 - face_hole_depth / 2 - wall)
        yrot(90) {
          diff("f_remove", "f_keep") {
            cyl(h=face_hole_depth + wall, d1=wall, d2=face_hole_diameter + wall * 2, $fn=360) {
              tag("f_remove")
                position(TOP) cyl(h=face_hole_depth, d=face_hole_diameter, $fn=360, anchor=TOP);
            }
          }
          tag("remove") up(face_hole_depth) cyl(h=face_hole_depth, d=face_hole_diameter, $fn=360);
        }
  }

  module mouth_hole() {
    up(mount_hole_z_offset)
      single_face_hole();
  }

  module eye_hole() {
    up(eye_holes_z_offset)
      single_face_hole();
  }

  module eyebrow_hole() {
    up(eyebrow_holes_z_offset)
      single_face_hole();
  }

  module face_holes() {
    position(BOTTOM) {
      mouth_hole();

      for (i = [-1, 1]) {
        eye_angels = 2 * asin(21.32 / face_diameter);
        zrot(eye_angels * i)
          eye_hole();
      }

      for (i = [-1, 1]) {
        eye_angels = 2 * asin(23.6 / face_diameter);
        zrot(eye_angels * i)
          eyebrow_hole();
      }
    }
  }

  module top_peg() {
    cyl(h=top_peg_height, d=top_peg_diameter, anchor=BOTTOM, $fn=fn_factor)
      tag("remove")
        cyl(h=top_peg_height + wall * 2, d=top_peg_diameter - wall * 2, anchor=CENTER, $fn=inner_fn_factor);
  }

  diff() {
    cyl(h=face_height, d=face_diameter, rounding=face_rounding, anchor=BOTTOM, $fn=fn_factor) {
      tag("remove")
        cyl(h=face_height - wall * 2, d=face_diameter - wall * 2, rounding=face_rounding, anchor=CENTER, $fn=inner_fn_factor);

      position(TOP)
        top_peg();

      // In low-poly we don't want the mouth hole in the edge,
      zrot((360 / fn_factor) / 2)
        face_holes();
    }
  }
}

model();
