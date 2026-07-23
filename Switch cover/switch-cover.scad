include <libraries/BOSL2/std.scad>

wall = 1.75;
inner_size = 62.25;
outer_size = inner_size + wall * 2;
inner_height = 15.0;
outer_height = inner_height + wall;

diff() {
  cuboid([outer_size, outer_size, outer_height], rounding=2, except_edges=[TOP], anchor=BOTTOM, $fn=80) {
    tag("remove")
      position(TOP) cuboid([inner_size, inner_size, inner_height], rounding=1, except_edges=[TOP], anchor=TOP, $fn=80);
  }
}
