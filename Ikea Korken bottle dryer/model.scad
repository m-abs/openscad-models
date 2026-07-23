include <../libraries/BOSL2/std.scad>

/**
 * Build model for Ikea Korken bottle dryer.
 */
module model() {
  $fn = 180;

  // Foot dimensions. The foot is a cross shaped piece, with drain piece in the middle and in each end.
  foot_length = 240; // This seems to work well for a 1L bottle and fitted on the first printer I made this on.
  foot_width = 50; // Width of the foot.
  thickness = 10; // Thickness of the foot. 10mm seems to be a good compromise between stability and print time.

  // The bottle is to be turn upside down, so the cone is at the bottom and the pole is inside the bottle.
  // To allow the water to drain, there are grooves cut into the cone, and the pole is made of 4 cylinders.
  cone_height = 25; // Arbitrary height of the cone. It can't be too high without loosing stability.
  cone_top_radius = pole_radius;
  cone_bottom_radius = foot_width / 2;
  // Pole dimensions.
  pole_diameter = 16; // Diameter of the pole, this needs to fit inside the bottle neck.
  pole_radius = pole_diameter / 2;
  pool_height = 80 - cone_height; // Height of the pole that is inside the bottle, this is the height of the pool minus the height of the cone.

  /**
    * Build a pole with 4 cylinders, with the given padding.
    * @param padding The padding to add to the radius of the pole. This is used to cut out a hole in the top of the pole.
    */
  module pole(padding = 0) {
    attach(TOP) color("lightgrey") linear_extrude(height=pool_height) {
          for (i = [0:1]) {
            glued_circles(r=(pole_radius + padding) / 2, spread=pole_radius + padding, spin=90 * i + 45);
          }
        }
  }

  /**
    * Build a cone with the given padding.
    * @param height_padding The padding to add to the height of the cone. This is used to make the cone taller than the pole.
    * @param size_padding The padding to add to the radius of the cone. This is used to make the cone wider than the pole.
    */
  module cone(height_padding = 5, size_padding = 0) {
    h = cone_height + height_padding;
    r1 = cone_bottom_radius + size_padding;
    r2 = cone_top_radius + size_padding;

    cyl(h=h, r1=r1, r2=r2, anchor=BOTTOM) {
      children();
    }
  }

  /**
    * Build a pole with a cone on top. The cone has grooves cut into the sides, and the pole has a hole cut out of the top.
    */
  module pole_with_cone() {
    position(BOTTOM) {
      diff() {
        // Start with the outer cone. Colored to make it easier to see the different parts in the preview.
        color("lightblue") cone() {
            // Cut out grooves in the side of the cone. The grooves are cut out by rotating a cube around the center of the cone.
            tag("remove") position(BOTTOM)for (i = [0:1]) {
                cube([5, cone_bottom_radius * 2, cone_height + 6], spin=90 * i, anchor=BOTTOM);
              }

            // Make the pole and cut out around it, so the water can drain. 
            down(4) {
              tag("keep") pole();

              // Cut out a hole in the top
              tag("remove") pole(2);
            }
          }

        // Finish by readding the inside of the cone, that was cut out by the grooves.
        color("lightgreen")
          tag("keep")
            cone(size_padding=-3);
      }
    }
  }

  module bottom_round_end() {
    position(BOTTOM)
      cyl(h=thickness, r=foot_width / 2, rounding2=5, anchor=BOTTOM) {
        children();
      }
  }

  /**
    * Build the bottom piece of the foot, this is a straight piece with a round end on each side. 
    * This is generated twice at 90 degrees to make the cross shape of the foot.
    */
  module bottom_piece() {
    // Length of the bottom piece without the round ends
    p_length = foot_length - foot_width / 2;

    // Middle bar
    cuboid([p_length, foot_width, thickness], rounding=5, edges=TOP, anchor=BOTTOM) {
      // Round ends
      for (i = [[LEFT, 1], [RIGHT, -1]]) {
        pos = i[0];
        yr = i[1] * 10;
        l = i[1] * 5;

        position(pos) {
          bottom_round_end() {
            move([l, 0, 4.2])
              yrot(yr) pole_with_cone();
          }
        }
      }

      // TODO: This is added twice, but I didn't care to fix it.
      pole_with_cone();
    }
  }

  for (z = [0, 90]) {
    zrot(z)
      bottom_piece();
  }
}

model();
