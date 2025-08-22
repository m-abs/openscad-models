include <../libraries/BOSL2/std.scad>

coin = "10-krone"; // ["10-krone", "20-krone"]

diff() {
  diamter = coin == "10-krone" ? 23.35 : 27;
  coin_thickness = (coin == "10-krone" ? 2.30 : 2.35);

  cut_out_height = coin_thickness + 0.25;

  holder_thickness = cut_out_height * 2 + 0.25;

  cyl(h=holder_thickness, d=diamter + 15, anchor=BOTTOM, chamfer=coin_thickness, $fn=360) {
    ring_dim = 5;
    right(ring_dim / 2) position(LEFT + BOTTOM) cyl(h=holder_thickness, d=ring_dim + 10, anchor=BOTTOM, chamfer=coin_thickness, $fn=360) {
          tag("remove") cyl(h=holder_thickness, d=ring_dim, rounding=-2, $fn=360);
        }

    position(TOP) tag("remove")
        cyl(h=cut_out_height, d=diamter + 1.6, chamfer2=cut_out_height / 2, anchor=TOP, $fn=360);
  }
}
