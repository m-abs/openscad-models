include <../libraries/BOSL2/std.scad>

make_screw_hole = true;

module screw_hole() {
  cyl(h=4.5, r1=5, r2=0, anchor=BOTTOM, $fn=60) {
    cyl(h=10, r=4.5 / 2, anchor=BOTTOM);
  }
}

module make() {
  wall_thickness = 1.75;

  // Scale dimensions
  scale_width = 131.2;
  scale_length = 170;
  scale_height = 30;
  scale_display_length = 39.5;
  scale_display_height = 15.95;

  // Inner dimensions
  inner_width = scale_width + wall_thickness;
  inner_length = scale_length + 2 * wall_thickness;
  inner_height = scale_height + 0.5;

  // Outer dimensions
  outer_width = inner_width + 2 * wall_thickness;
  outer_length = inner_length;
  outer_height = inner_height + wall_thickness;

  // Display support dimensions
  display_support_offset = scale_display_length + wall_thickness;
  display_support_length = wall_thickness * 2;
  display_support_height = scale_height - scale_display_height;

  // Wedge dimensions
  wedge_width = outer_width;
  wedge_length = inner_length - display_support_offset - 2 * wall_thickness;
  wedge_height = inner_height + 2 * wall_thickness;

  diff() {
    rect_tube(h=inner_length, isize=[inner_width, inner_height], wall=wall_thickness, anchor=BOTTOM) {
      // Front support
      position(BACK + BOTTOM) fwd(wall_thickness) {
          up(display_support_offset) {
            cuboid(
              [inner_width, display_support_height, display_support_length], chamfer=wall_thickness,
              anchor=BACK + BOTTOM, edges=TOP + FRONT
            );
          }

          cuboid(
            [display_support_length, display_support_height, display_support_offset],
            anchor=BACK + BOTTOM
          );
        }

      // Make the wedge cutout
      position(TOP) tag("remove") {
          down(wedge_length) rot([180, 0, 180]) wedge([wedge_width, wedge_height, wedge_length], anchor=TOP) {
                /*
                     fwd((wedge_height - wall_thickness) / 2)
                     {
                         cuboid([ inner_width, wall_thickness, wedge_length ]);
                     } */
              }
        }

      if (make_screw_hole) {
        // Wall plate needs to be thicker to accommodate screw holes
        position(BACK) {
          back(wall_thickness / 2) cuboid([outer_width, wall_thickness, outer_length], anchor=BACK);

          // Make screw holes
          tag("remove") {
            y_row = -90;
            up_val = -wall_thickness;

            wall_offset = 20;

            back(-wall_thickness) {
              xrot(y_row) #screw_hole();

              down(wall_offset) {
                position(TOP + LEFT) right(wall_offset) xrot(y_row) #screw_hole();
                position(TOP + RIGHT) left(wall_offset) xrot(y_row) #screw_hole();
              }
            }
          }
        }
      }
    }
    ;
  }
}

make();
