include <../libraries/BOSL/constants.scad>
include <./constants.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/threading.scad>
use <../libraries/BOSL/transforms.scad>

// Make the lip thread.
// It will be added to the top of the pusher and cut out of the bottom of the lid.
module lip_thread()
{
    threaded_rod(d = pusher_top_width, l = pusher_thread_length, pitch = 1.5, bevel = true, align = V_TOP, $fn = 160);
}

// Make the top piece of the pusher, it has a round bottom and a straight top.
module top_piece()
{
    // Radius of the top.
    r = pusher_top_width / 2;

    // Roundish bottom of the top.
    difference()
    {
        // Make a squashed hollow sphere.
        Z_SCALE = 0.5;
        zscale(Z_SCALE) staggered_sphere(r = r, align = V_TOP, $fn = 360);
        zscale(Z_SCALE) staggered_sphere(r = r - pusher_wall, align = V_TOP, $fn = 360);

        // Cut off the top half of the sphere.
        cyl(l = pusher_top_width, r = r, align = V_TOP);
    }

    // Straight top of the top.
    difference()
    {
        // Height of the straight part, is the total height minus the height of the round part and minus the height of
        // the thread.
        h = pusher_top_height - pusher_thread_length;

        union()
        {
            cyl(l = h, r = r, align = V_TOP, $fn = 360);
            up(h) lip_thread();
        }
        down(1) cyl(l = h + pusher_wall * 2 + pusher_thread_length, r = r - pusher_wall, align = V_TOP, $fn = 140);
    }
}

module pusher()
{
    difference()
    {
        // The bottom piece is narrower at the start than at the end.
        r1 = pusher_bottom_start_width / 2;
        r2 = pusher_bottom_end_width / 2;

        // Make the solid part of the bottom.
        union()
        {
            // make a small rounded bottom.
            zscale(8 / r1) staggered_sphere(r = r1, align = V_TOP, $fn = 180);

            // make the bottom cylinder.
            cyl(l = pusher_bottom_height, r1 = r1, r2 = r2, align = V_TOP, $fn = 180);

            // make the top piece.
            up(pusher_bottom_height + pusher_top_width / 4 - pusher_wall * 2) top_piece();
        }

        // Hollow out the bottom.
        up(pusher_wall) cyl(l = pusher_bottom_height + pusher_wall, r1 = r1 - pusher_wall, r2 = r2 - pusher_wall,
                            align = V_TOP, $fn = 80);
    }
}

module lid()
{
    ymove(100) difference()
    {
        r = pusher_top_width / 2 + pusher_wall;

        // make a small rounded bottom.
        union()
        {
            up(pusher_lid_height) scale([ 1, 1, 5 / r ]) staggered_sphere(r = r, align = V_TOP, $fn = 180);
            cyl(l = pusher_lid_height, r = r, align = V_TOP, $fn = 160);
        }
        down(pusher_wall)
        {
            cyl(l = pusher_lid_height, r = r - pusher_wall, align = V_TOP);
            lip_thread();
        }
    }
}

pusher();
lid();