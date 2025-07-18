include <../libraries/BOSL2/std.scad>

coin = "10-krone"; // ["10-krone", "20-krone"]

diamter = coin == "10-krone" ? 23.35 : 27;
coin_thickness = (coin == "10-krone" ? 2.30 : 2.35);

diff() {
  holder_thickness = 5;
  cyl(h=holder_thickness, d=diamter + 15, anchor=BOTTOM, chamfer=2, $fn=360) {
    ring_dim = 5;
    right(ring_dim / 2) position(LEFT + BOTTOM) cyl(h=holder_thickness, d=ring_dim + 10, anchor=BOTTOM, rounding=1.5, $fn=360) {
          tag("remove") cyl(h=holder_thickness, d=ring_dim, rounding=-2, $fn=360);
        }

    cut_out_height = coin_thickness + 0.25;

    position(TOP) tag("remove")
        cyl(h=cut_out_height, d=diamter + 1.6, chamfer2=cut_out_height / 2, anchor=TOP, $fn=360);
  }
}
