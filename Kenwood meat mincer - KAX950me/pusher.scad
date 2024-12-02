include <../libraries/BOSL/constants.scad>
use <../libraries/BOSL/masks.scad>
use <../libraries/BOSL/shapes.scad>
use <../libraries/BOSL/threading.scad>
use <../libraries/BOSL/transforms.scad>

$fn = 360;

wall = 2.5;

bottom_start_width = 40;
bottom_end_width = 43.3;
bottom_height = 100;

top_start_width = 58.8;
top_end_width = 70;
top_height = 49;

lid_height = 12;
thread_length = 5;

module lip_thread()
{
    threaded_rod(d = top_end_width - wall, l = thread_length, pitch = 1.25, align = V_TOP);
}

module top()
{
    r = top_end_width / 2;

    // Roundish bottom of the top.
    difference()
    {
        // Make a squashed sphere.
        Z_SCALE = 0.5;
        zscale(Z_SCALE) sphere(r = r);
        zscale(Z_SCALE) sphere(r = r - wall);

        // Cut off the top half of the sphere.
        cylinder(h = top_end_width, r = r);
    }

    // Straight top of the top.
    difference()
    {
        h = top_height - (0.5 * r);

        union()
        {
            cylinder(h = h - thread_length, r = r);
            up(h - thread_length) lip_thread();
        }
        down(wall)
        {
            cylinder(h = h + wall * 2 + thread_length, r = r - wall);
        }
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
            scale([ 1, 1, 4 / r1 ])
            {
                sphere(r = r1);
            }

            // make the bottom cylinder.
            cylinder(h = bottom_height, r1 = r1, r2 = r2);

            // make the top piece.
            translate([ 0, 0, bottom_height + 12.5 ])
            {
                top();
            }
        }

        // Hollow out the bottom.
        translate([ 0, 0, wall ])
        {
            cylinder(h = bottom_height + wall, r1 = r1 - wall, r2 = r2 - wall);
        }
    }
}

module lid()
{
    ymove(100)
    {
        difference()
        {
            r = top_end_width / 2;
            cyl(l = lid_height, r = r, fillet2 = 2, align = V_TOP);
            down(wall) cyl(l = lid_height, r = r - wall, align = V_TOP);
            lip_thread();
        }
    }
}

pusher();
lid();