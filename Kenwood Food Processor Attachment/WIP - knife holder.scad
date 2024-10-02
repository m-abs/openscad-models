include <../libraries/Round-Anything/polyround.scad>
include <../libraries/dotSCAD/src/box_extrude.scad>

radiiPoints = [ [ -4, 0, 1 ], [ 5, 3, 1.5 ], [ 0, 7, 0.1 ], [ 8, 7, 10 ], [ 20, 20, 0.8 ], [ 10, 0, 10 ] ];
box_extrude(height = 5, shell_thickness = 0.5, bottom_thickness = 0.5) polygon(polyRound(radiiPoints, 30));