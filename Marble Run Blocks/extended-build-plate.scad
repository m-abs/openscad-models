// The Grid2x2 is a bit difficult to place for a child, so this script
// generates a build plate with multiple Grid2x2 blocks on it.

// The Grid2x2 is 60x60mm
// The attached blocks (the 2x2 pegs) are 20x20mm
// and the connection between the blocks is 20mm.

// If we offset the blocks by 40mm, the attached blocks will overlap
// and we can extend the grid in both directions.
include <./tools.scad>

x_repeats = 2;
y_repeats = 3;

buildPlate(x_repeats, y_repeats);
