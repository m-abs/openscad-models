include <../libraries/BOSL2/std.scad>;

make_model = "face"; // ["face", "lid", "pot","full_head"]
dev_mode = true; // If true, render with lower $fn for faster rendering while modeling. Set to false for final render.
low_poly = true; // If true, make a low-poly version of the model with fewer faces.

size = "medium"; // ["small", "medium", "large"]

module model() {
  fn_factor = low_poly ? 16 : 360;
  inner_fn_factor = dev_mode ? 60 : 360; // Lower to 60 while modeling to speed up rendering, but set to 360 for final print.

  // Measurements taken from https://www.printables.com/model/177412-lego-head-planter-easier-print
  neck_height = 11;

  original_neck_diameter = 110;
  original_face_diameter = 152;
  original_face_height = 135;

  scale_factor = size == "small" ? 0.72 : size == "medium" ? 1 : size == "large" ? 1.18 : 1;

  neck_diameter = original_neck_diameter * scale_factor;

  head_height = original_face_height * scale_factor;

  // Original lego head planter is 135 mm tall and 11 mm top height, use that to calculate face hole offsets.
  face_height = head_height - neck_height;

  face_hole_diameter = 3;
  face_hole_depth = 5;

  wall = 3;

  face_diameter = original_face_diameter * scale_factor;

  // The original model the face holes are:
  // - Mouth hole center is 38.5 mm from the top of the head
  // - Eye holes center is 70 mm from the top of the head
  // - Eyebrow holes center is 96 mm from the top of the head
  // I adjust 2 mm down to make the lid fit.
  mount_hole_z_offset = 38.5 * scale_factor - 2;
  eye_holes_z_offset = 70 * scale_factor - 2;
  eyebrow_holes_z_offset = 96 * scale_factor - 2;

  face_rounding = face_height * 0.16;

  // Make a face hole with closed back. This reduces the need for thicker walls.
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

  // Make a hole for the mouth.
  module mouth_hole() {
    up(mount_hole_z_offset)
      single_face_hole();
  }

  // Make a hole for an eye.
  module eye_hole() {
    up(eye_holes_z_offset)
      single_face_hole();
  }

  // Make a hole for an eyebrow.
  module eyebrow_hole() {
    up(eyebrow_holes_z_offset)
      single_face_hole();
  }

  // Make all the face holes.
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

  // Make the neck, which is a simple cylinder with a hole in it.
  module neck() {
    tube(h=neck_height, od=neck_diameter, wall=wall, anchor=BOTTOM, $fn=fn_factor, ifn=inner_fn_factor);
  }

  // Make the full head with face holes and neck. I don't recommend printing this one.
  module full_head() {
    diff() {
      cyl(h=face_height, d=face_diameter, rounding=face_rounding, anchor=BOTTOM, $fn=fn_factor) {
        tag("remove")
          up(wall)
            position(TOP)
              cyl(
                h=face_height - wall * 2,
                d=face_diameter - wall * 2,
                rounding1=face_rounding,
                chamfer2=(face_diameter - neck_diameter) / 2 + wall,
                anchor=TOP,
                $fn=inner_fn_factor
              );

        position(TOP)
          neck();

        // In low-poly we don't want the mouth hole in the edge,
        zrot((360 / fn_factor) / 2)
          face_holes();

        children();
      }
    }
  }

  // Make just the face. This requires the lid to be printed separately.
  module face() {
    height = face_height - face_rounding;
    diff() {
      cyl(h=height, d=face_diameter, rounding1=face_rounding, anchor=BOTTOM, $fn=fn_factor) {
        tag("remove")
          position(TOP)
            cyl(
              h=height - wall,
              d=face_diameter - wall * 2,
              rounding1=face_rounding,
              anchor=TOP,
              $fn=inner_fn_factor
            );

        // In low-poly we don't want the mouth hole in the edge,
        zrot((360 / fn_factor) / 2)
          face_holes();
      }
    }
  }

  // Make the lid part of the model.
  module lid() {
    height = face_rounding;
    diff() {
      cyl(h=height, d=face_diameter, rounding2=face_rounding, anchor=BOTTOM, $fn=fn_factor) {
        tag("remove")
          up(wall)
            position(TOP)
              cyl(
                h=height + wall * 2,
                d=face_diameter - wall * 4,
                chamfer2=(face_diameter - neck_diameter) / 2,
                anchor=TOP,
                $fn=inner_fn_factor
              );

        position(TOP)
          neck();

        position(BOTTOM) cyl(h=wall, d=(face_diameter - wall * 2), anchor=TOP, $fn=inner_fn_factor);
      }
    }
  }

  // Make an inner pot.
  // TODO: Make this generic and move it to another file, to be shared between projects.
  module inner_pot() {
    top_r = (neck_diameter - wall * 2) / 2 - 0.5;
    bottom_r = top_r / 3;
    edge_r = neck_diameter / 2;
    edge_h = 1.8;

    pod_height = head_height + edge_h - wall;
    bottom_h = pod_height * 0.225;
    top_h = pod_height - bottom_h;

    module pod_edge() {
      tube(h=edge_h, or=edge_r, wall=edge_r - top_r, anchor=TOP, $fn=inner_fn_factor);
    }

    tube(h=top_h, or1=top_r, or2=top_r, wall=wall, anchor=BOTTOM, $fn=inner_fn_factor) {
      position(TOP)
        pod_edge();

      diff() {
        position(BOTTOM)
          tube(h=bottom_h, or2=top_r, or1=bottom_r, wall=wall, anchor=TOP, $fn=inner_fn_factor) {
            drain_hole_r = 1.75;

            vertical_spacing = drain_hole_r + wall * 2;

            tag("remove")for (u = [wall + drain_hole_r:vertical_spacing:bottom_h])
              up(u)for (i = [0:360 / 5:360]) {
                position(BOTTOM) zrot(i) cyl(h=(top_r + wall) * 2, r=drain_hole_r, orient=LEFT);
              }

            position(BOTTOM) cyl(h=wall, r=bottom_r, anchor=BOTTOM);
          }
      }
    }
  }

  if (make_model == "full_head") {
    full_head();
  } else if (make_model == "face") {
    face();
  } else if (make_model == "lid") {
    lid();
  } else if (make_model == "pot") {
    inner_pot();
  }
}

model();
