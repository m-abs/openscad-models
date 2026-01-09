include <../../libraries/BOSL2/std.scad>

// rect_tube(h=20, size=[30, 130], wall=2, rounding=15);
diff() {
  wall = 3.75;
  depth = 20;
  width = 127;
  height = 31;

  rounding = height / 2;

  except_edges = [TOP, LEFT, RIGHT];

  cuboid(size=[depth, width, height], rounding=rounding, except_edges=except_edges, anchor=BOTTOM + LEFT, $fn=360) {
    cutout_depth = (depth - wall) / 2;
    cutout_height = height - wall;
    cutout_width = width - wall * 2;

    cutout_rounding = cutout_height / 2;

    cutout_size = [cutout_depth, cutout_width, cutout_height];
    cutout_size2 = [cutout_depth - 2, cutout_width];
    tag("remove") {
      position(LEFT + TOP) right(cutout_depth / 2) {
          cuboid(size=cutout_size, rounding=cutout_rounding, except_edges=except_edges, anchor=TOP, $fn=360);
        }
      position(RIGHT + TOP) left(cutout_depth / 2) {
          cuboid(size=cutout_size, rounding=cutout_rounding, except_edges=except_edges, anchor=TOP, $fn=360);
        }
      position(TOP) up(2) cuboid(size=[depth, width / 2, 8 * 2], rounding=8);
    }
  }
}
