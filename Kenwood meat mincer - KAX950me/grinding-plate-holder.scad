// Out width of the locking ring: 76.2mm
// Axel diameter: 9mm
// Stack height: 36.5mm (locking ring + 3x grinding plates + 1x knife).

include <../libraries/BOSL/constants.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/threading.scad>
use <../libraries/BOSL/transforms.scad>

wall = 5;
module pin()
{
    pin_length = 36.5 + wall;
    cyl(l = pin_length, r = 4.5, align = V_TOP);
    up(pin_length) threaded_rod(l = 10, d = 9, pitch = 1.25, align = V_TOP);
}

pin();
left(20) threaded_nut(od = 20, id = 9, h = 5, pitch = 1.25, align = V_TOP, $slop = 1);