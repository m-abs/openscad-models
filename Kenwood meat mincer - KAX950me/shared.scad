include <../libraries/BOSL/constants.scad>
include <./constants.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/threading.scad>
use <../libraries/BOSL/transforms.scad>

// START - pusher shared code

/*
Make the pusher lip thread.

It will be added to the top of the pusher and cut out of the bottom of the lid.
*/
module pusher_lid_thread() {
  threaded_rod(d=pusher_top_width, l=pusher_thread_length, pitch=4, bevel=true, align=V_TOP, $fn=160);
}

// END - pusher shared code
