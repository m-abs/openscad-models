include <../libraries/BOSL2/std.scad>;

/**
  * Generic inner pod for planters etc.
  * The pod is intended to have a narrowing bottom part with drainage holes.
  *
  * @param wall The thickness of the walls of the pod. Don't make it too thin, I recommend at least 2mm.
  * @param bottom_h The height of the bottom of the pod, if unspecified it will be calculated as 22.5% of the total pod height.
  * @param pod_height The total height of the pod.
  * @param top_r The radius of the top of the pod.
  * @param bottom_r The radius of the bottom of the pod.
  * @param edge_width The width of the edge that extends around the top of the pod, if edge_h is specified.
  * @param edge_h The height of the edge around the top of the pod.
  * @param drain_hole_r The radius of the drainage holes in the bottom part of the pod. Defaults to 1.75mm. They shouldn't be smaller than this.
  * @param edge_fn_factor The number of facets for the edge around the top of the pod.
  * @param inner_fn_factor The number of facets for the inner surface of the pod.
  */
module inner_pod(
  wall,
  pod_height,
  bottom_h,
  top_r,
  bottom_r,
  edge_h,
  edge_width,
  drain_hole_r = 1.75,
  edge_fn_factor = 180,
  inner_fn_factor = 180
) {
  bottom_h = bottom_h && bottom_h > 0 ? bottom_h : pod_height * 0.225;
  top_h = pod_height - bottom_h;

  assert(wall > 0, "wall must be greater than 0");
  assert(pod_height > 0, "pod_height must be greater than 0");
  assert(top_r > 0, "top_r must be greater than 0");
  assert(bottom_r >= 0, "bottom_r must be greater than or equal to 0");
  assert(bottom_h > 0, "bottom_h must be greater than 0");
  assert(top_h > 0, "top_h must be greater than 0");

  assert(top_r >= bottom_r, "top_r must be greater than or equal to bottom_r");
  if (top_r == bottom_r) {
    echo("Warning: top_r is equal to bottom_r, the pod will be a cylinder.");
  }

  module pod_edge() {
    if (edge_h && edge_h > 0) {
      assert(edge_width > 0, "edge_width must be greater than 0 if edge_h is greater than 0");

      position(TOP)
        tube(h=edge_h, ir=top_r - wall, wall=edge_width, anchor=TOP, $fn=edge_fn_factor);
    }
  }

  // Make a tube for the top part of the pod.
  tube(h=top_h, or1=top_r, or2=top_r, wall=wall, anchor=BOTTOM, $fn=inner_fn_factor) {
    // Add the optional edge around the top of the pod.
    pod_edge();

    // Make a tube for the bottom part of the pod, with drainage holes.
    diff() {
      position(BOTTOM)
        tube(h=bottom_h, or2=top_r, or1=bottom_r, wall=wall, anchor=TOP, $fn=inner_fn_factor) {

          vertical_spacing = drain_hole_r + wall * 2;

          tag("remove")for (u = [wall + drain_hole_r:vertical_spacing:bottom_h])
            up(u)for (i = [0:360 / 5:360]) {
              position(BOTTOM) zrot(i) cyl(h=(top_r + wall) * 2, r=drain_hole_r, orient=LEFT);
            }

          position(BOTTOM)
            cyl(h=wall, r=bottom_r, anchor=BOTTOM);
        }
    }
  }
}

inner_pod(wall=3, pod_height=200, top_r=100, bottom_r=20, edge_h=1.8, edge_width=5);
