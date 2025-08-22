include <../libraries/BOSL2/std.scad>

// Diameter of the top of the funnel
mouth_diameter = 80;

// Height of the mouth edge, set to 0 to remove.
mouth_height = 5;

// Height of the funnel's bowl
bowl_height = 40;

// Height of the funnel's spout, e.g. the part that goes into the bottle
spout_height = 50;

// Diameter of the top of the funnel's spout
spout_diameter_top = 18;

// Diameter of the bottom of the funnel's spout
spout_diameter_bottom = 14;

// Thickness of the funnel's walls
wall_thickness = 2.25;

$fn = 180;

if (mouth_height > 0) {
  tube(h=mouth_height, od=mouth_diameter, wall=wall_thickness, anchor=BOTTOM);
}

up(mouth_height)
  tube(h=bowl_height, od1=mouth_diameter, od2=spout_diameter_top, wall=wall_thickness, anchor=BOTTOM) {
    up(bowl_height) {
      position(BOTTOM) tube(
          h=spout_height, od1=spout_diameter_top, od2=spout_diameter_bottom,
          wall=wall_thickness, anchor=BOTTOM
        );
    }
  }
