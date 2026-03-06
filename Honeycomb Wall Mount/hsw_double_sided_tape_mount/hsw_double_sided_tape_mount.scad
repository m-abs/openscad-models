include <../../libraries/BOSL2/std.scad>
include <../../libraries/BOSL2/threading.scad>

// HSW OpenSCAD Double Sided Tape Mounting Hardware, by Wesley Aptekar-Cassles
//
// Based on HSW - Scotch 3M Double Sided Tape / Command Strip Mount V2, by C3D (@Shamanec_493218)
//
// For Honeycomb storage wall, by RostaP
//
// With some code taken from OpenSCAD Parameterized Honeycomb Storage Wall, by Wireheadarts
//
// License: CC BY-NC 4.0 (https://creativecommons.org/licenses/by-nc/4.0/)

// Downloaded from: https://www.printables.com/model/1150426-hsw-openscad-double-sided-tape-mounting-hardware on 6 of March 2026.

/* [Main options] */
// How many cells long this strip will be.
strip_length = 4;
// The width of your double sticky tape in mm.
strip_width = 22;
// Whether this will be mounted horizontally or vertically on the wall.
orientation = "vertical"; // ["vertical", "horizontal"]

assert(strip_length % 2 == 1 || orientation == "vertical", "Horizontal orientations must be in a length that is not a multiple of two!");

/* [Detailed options] */
strip_thickness = 1.5;
hole_depth = 5;
strip_extra_length = 17.8;
bolt_height = 9;
bolt_size = 10.2;
bolt_pitch = 1.5;
hsw_insert_tolerance = 0.2;

/* [Hidden] */
hsw_insert_width = 13.4;
hsw_vertical_pitch = 23.6;
hsw_horizontal_pitch = 40.88 / 2;

// Calculates the long diagonal (the diameter of a circle inscribed on the hexagon) from the short diagonal (the height of the hexagon)
function ld_from_sd(short_diameter) =
  (2 / sqrt(3) * short_diameter);

module bolt_hole() {
  difference() {
    cylinder(h=bolt_height, d=ld_from_sd(hsw_insert_width - hsw_insert_tolerance), $fn=6);
    translate([0, 0, hole_depth / 2]) threaded_rod(bolt_size, hole_depth, bolt_pitch, internal=true);
  }
}

rotate([180, 0, 0])
  union() {
    pitch = (orientation == "vertical") ? hsw_vertical_pitch : hsw_horizontal_pitch;
    hex_rotation = (orientation == "vertical") ? 30 : 0;

    zrot(hex_rotation) bolt_hole();

    translate([-strip_extra_length / 2, -strip_width / 2, bolt_height])
      cube([(strip_length - 1) * pitch + strip_extra_length, strip_width, strip_thickness]);

    translate([pitch * (strip_length - 1), 0, 0])
      zrot(hex_rotation) bolt_hole();
  }
