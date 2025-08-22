include <../libraries/BOSL2/std.scad>

outer_diameter = 15.95;
wall_thickness = 3;
height = 130;
connecter_height = 30;

mode = "connector"; // [top,connector]

module model() {
  $fn = 180;
  function calculate_inner_height(mode, height, connecter_height) =
    mode == "top" ? (height - connecter_height) : (height - 0.1);

  outer_height = height;
  inner_height = calculate_inner_height(mode, height, connecter_height);

  offset = connecter_height;

  tube(h=outer_height, od=outer_diameter, wall=wall_thickness, anchor=BOTTOM)

    up(offset) position(BOTTOM) cyl(h=inner_height, d=outer_diameter - wall_thickness * 2, anchor=BOTTOM);
}

model();
