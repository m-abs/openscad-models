side_height=100;
wall_thickness=2.5;
grater_width=157;
bottom_length=200;

shelf_width=5;
shelf_thickness=1.5;

shelf_interval=shelf_width + shelf_thickness;

module end()
{
    cube([wall_thickness, grater_width, side_height]);
}

module shelf()
{
    color("#fefefe")
    difference() {
        cube([shelf_thickness, grater_width, side_height]);
        translate([-1, shelf_thickness, wall_thickness]) cube([shelf_width, grater_width - shelf_width, side_height]);
    };
}

module side()
{
    cube([bottom_length, wall_thickness, side_height]);
}

union()
{
  translate([0, wall_thickness, wall_thickness]) end();
  translate([0, 0, wall_thickness]) side();
  cube([bottom_length, grater_width + 2*wall_thickness, wall_thickness]);
  translate([bottom_length - wall_thickness, wall_thickness, wall_thickness]) end();
  translate([0, grater_width + wall_thickness, wall_thickness]) side();
    
   for (offset = [shelf_interval + wall_thickness: shelf_interval: bottom_length - shelf_interval])
   {
        translate([offset, wall_thickness, wall_thickness]) shelf();
   }
}