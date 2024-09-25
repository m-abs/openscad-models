/*
 * This is a stand for the Kenwood Food Processor grater discs for a Kenwood Foodprocessor (KAH65PL) attachment.
 */

/*
 * The grater discs are 156.7 mm in diameter, so I will make the inner diameter 160 mm to be sure it fits.
 */
inner_diameter = 160;

/**
 * The height of the inner part of the cylinder. 208 mm is minimum height for the grater discs to fit.
 */
inner_height = 220;

/*
    The wall thickness.
*/
wall = 2.5;

/*
    Calculate the outer diameter of the cylinder.

    The outer diameter is determined by adding twice the wall thickness to the inner diameter.

    Variables:
    - inner_diameter: The diameter of the inner part of the cylinder.
    - wall: The thickness of the cylinder wall.
*/
outer_diameter = inner_diameter + wall * 2;

module pipe()
{
    difference()
    {
        cylinder(d = outer_diameter, h = inner_height, $fn = 100);
        // Make hollow
        translate([ 0, 0, wall ]) cylinder(d = inner_diameter, h = inner_height + 1, $fn = 100);

        // Make openings
        translate([ -inner_diameter + 20, 0, -5 ]) rotate([ 0, 20, 0 ])
            cylinder(d = inner_diameter, h = inner_height * 1.20, $fn = 100);
        translate([ inner_diameter - 20, 0, -5 ]) rotate([ 0, -20, 0 ])
            cylinder(d = inner_diameter, h = inner_height * 1.20, $fn = 100);
    }
}

/*
 * Module: peg
 *
 * Description:
 * Makes the middle peg for the holder, for the grate to be attached to.
 *
 * File Path:
 * /home/mabs/project/mabs.dk/openscad-models/Kenwood Food Processor Attachment/Grater holder/attempt2 - cylinder.scad
 *
 * Usage:
 * Call this module to create the middle peg.
 *
 * Example:
 * peg();
 */
module peg()
{
    difference()
    {
        translate([ 0, 0, wall ]) cylinder(d = 37, h = 28, $fn = 100);
        translate([ 0, 0, wall ]) cylinder(d = 29, h = 30, $fn = 100);
    }
}

module make_stand()
{
    pipe();
    peg();
}

make_stand();