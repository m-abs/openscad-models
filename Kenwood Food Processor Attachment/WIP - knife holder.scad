/**
 * Module: half_sphere
 * 
 * Description:
 * This module creates a half sphere with a specified diameter and height.
 * It uses the difference() function to subtract a cube from a sphere to create the half sphere shape.
 * 
 * Parameters:
 * - diameter: The diameter of the half sphere.
 * - height: The height of the half sphere.
 * 
 * Usage:
 * To use this module, call the half_sphere() function and pass in the desired diameter and height.
 * The function will return a half sphere shape.
 */
module half_sphere(diameter, height)
{
  scale_factor = diameter / height;
  scale([scale_factor, scale_factor, 1])
  difference() {
    sphere(r=height / 2, $fn=100); // Full sphere
    translate([-height/2, -height/2, -height]) cube([height, height, height]);
  };
}

module middle_stick()
{
  diameter = 43.5;
  cylinder_height = 17;
  top_height = 8;
  union() {
    cylinder(h = cylinder_height, r = diameter / 2, $fn=100);
    translate([0, 0, cylinder_height]) half_sphere(diameter, top_height);
  };
}

middle_stick();