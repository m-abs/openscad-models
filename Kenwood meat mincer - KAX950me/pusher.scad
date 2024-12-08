include <../libraries/BOSL/constants.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/threading.scad>
use <../libraries/BOSL/transforms.scad>

wall = 2.25;

bottom_start_width = 40;
bottom_end_width = 43.3;
bottom_height = 100;

top_start_width = 58.8;
top_end_width = 70;
top_height = 70;

lid_height = 12;
thread_length = lid_height - wall;

module lip_thread()
{
    threaded_rod(d = top_end_width - wall / 2, l = thread_length, pitch = 1.5, $fn = 160, align = V_TOP);
}

module top()
{
    // Radius of the top.
    r = top_end_width / 2;

    // Roundish bottom of the top.
    difference()
    {
        // Make a squashed hollow sphere.
        Z_SCALE = 0.5;
        zscale(Z_SCALE) staggered_sphere(r = r, $fn = 360, align = V_TOP);
        zscale(Z_SCALE) staggered_sphere(r = r - wall, $fn = 360, align = V_TOP);

        // Cut off the top half of the sphere.
        cylinder(h = top_end_width, r = r, $fn = 360, align = V_TOP);
    }

    // Straight top of the top.
    difference()
    {
        // Height of the straight part, is the total height minus the height of the round part and minus the height of
        // the thread.
        h = top_height - (0.5 * r) - thread_length;

        union()
        {
            cylinder(h = h, r = r, $fn = 360);
            up(h + thread_length / 2) lip_thread();
        }
        down(wall) cyl(l = h + wall * 2 + thread_length, r = r - wall, $fn = 360, align = V_TOP);
    }
}

module pusher()
{
    difference()
    {
        // The bottom piece is narrower at the start than at the end.
        r1 = bottom_start_width / 2;
        r2 = bottom_end_width / 2;

        // Make the solid part of the bottom.
        union()
        {
            // make a small rounded bottom.
            zscale(8 / r1) staggered_sphere(r = r1, $fn = 180, align = V_OP);

            // make the bottom cylinder.
            cylinder(h = bottom_height, r1 = r1, r2 = r2, $fn = 360);

            // make the top piece.
            up(bottom_height + 13) top();
        }

        // Hollow out the bottom.
        up(wall) cylinder(h = bottom_height + wall, r1 = r1 - wall, r2 = r2 - wall);
    }
}

module lid()
{
    ymove(100)
    {
        difference()
        {
            // Used to align = V_TOP but gave:
            // WARNING: Object may not be a valid 2-manifold and may need repair!
            r = top_end_width / 2;

            // make a small rounded bottom.
            union()
            {
                up(lid_height) scale([ 1, 1, 5 / r ])
                {
                    staggered_sphere(r = r, $fn = 180, align= V_TOP);
                }
                cyl(l = lid_height, r = r, $fn = 160, align = V_TOP);
            }
            down(wall)
            {
                cyl(l = lid_height, r = r - wall, align = V_TOP);
                lip_thread();
            }
        }
    }
}

pusher();
lid();