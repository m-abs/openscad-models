/**
 * Attempt to create a holder for Senseo coffee pads.
 *
 * Idea is you twist, it is not finished as I gave up and just bought a glass container :p
 **/

inner_width = 80;
inner_height = 170;
inner_radius = inner_width / 2;

wall_thickness = 2;
buffer = 0.5;

outer_width = inner_width + (wall_thickness + buffer) * 2;
outer_radius = outer_width / 2;

buttom_radium = inner_radius + 5;

module hollowCylinder(h, r, wall)
{
    difference()
    {
        cylinder(h = h, r = r, $fn = 200);
        translate([ 0, 0, -1 ]) cylinder(h = h + 2, r = r - wall, $fn = 200);
    }
}

// Create the bottom disc with high-friction surface
module bottom_disc(h, r, bump_count = 48)
{
    friction_bump_height = h * 0.92;
    friction_bump_width = 1.2;

    cylinder(h = h, r = r, center = false, $fn = 100);

    for (i = [0:bump_count - 1])
    {
        angle = 360 / bump_count * i;
        rotate(angle) translate([ r - friction_bump_width / 2, 0, (h - friction_bump_height) / 2])
        {
            // Bump
            cylinder(h = friction_bump_height, r = friction_bump_width, center = false, $fn = 100);
        }
    }
}

module innerCylinder()
{
    union()
    {
        difference() {
            bottom_disc(15, buttom_radium);
            translate([0, 0, 13]) hollowCylinder(10, outer_radius, wall_thickness + buffer);
        }
        translate([0,0, 15])
        difference()
        {
            hollowCylinder(inner_height, inner_radius, wall_thickness);
            translate([ -inner_radius, 10, -1 ]) cube([ 80, 80, inner_height + 2 ], center = false);
        }
    }
}

module outerCylinder()
{
    translate([0, 100])
    rotate(40)
    union()
    {
        difference() {
            bottom_disc(15, buttom_radium);
            translate([0, 0, 13]) hollowCylinder(10, inner_radius + buffer, wall_thickness + buffer * 2);
        }
        translate([0,0, 15])
        difference()
        {
            hollowCylinder(inner_height, outer_radius, wall_thickness);
            translate([ -inner_radius, 10, -1 ]) cube([ 80, 80, inner_height + 2 ], center = false);
        }
    }
}

// Combine the components
module assembly()
{
    innerCylinder();
    outerCylinder();
}

// Generate the assembly
assembly();