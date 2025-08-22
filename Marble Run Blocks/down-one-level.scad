include <../libraries/BOSL2/std.scad>
include <./tools.scad>

mode = 3; // [1:Top, 2:Middle, 3:Bottom, 4:Full]

module render(mode) {
  shape = [rect([tunnel_width, tunnel_width], rounding=9.5, $fn=160)];

  bHeight = block_height;
  cutoutMiddlePiece = true;
  sweepPosition = TOP;

  topPieceTForm = [for (a = [90:-5:0]) xrot(a, cp=[0, -20])];
  bottomPieceTForm = [for (a = [0:5:90]) yrot(a, cp=[-20, 0])];

  if (mode == 1) {
    cutoutMiddlePiece = false;
    tForms = topPieceTForm;
    sweepPosition = TOP;

    marbleRunBlock(block_height, false) {
      remove() position(TOP) down(block_height) sweep(shape, tForms, closed=false, caps=true);
    }
  } else if (mode == 2) {
    cutoutMiddlePiece = false;
    sweepPosition = CENTER;

    marbleRunBlock(block_height, false) {
      remove() position(CENTER) cuboid(
            [tunnel_width, tunnel_width, block_height + 2], rounding=9.5,
            except=[TOP, BOTTOM], $fn=160
          );
    }
  } else if (mode == 3) {
    tForms = bottomPieceTForm;
    sweepPosition = TOP;

    marbleRunBlock(block_height) {
      remove() position(TOP) sweep(shape, tForms, closed=false, caps=true);
    }
  } else if (mode == 4) {
    tForms = concat(topPieceTForm, bottomPieceTForm);
    bHeight = double_block_height;
    sweepPosition = CENTER;

    marbleRunBlock(double_block_height) {
      remove() position(CENTER) #sweep(shape, tForms, closed=false, caps=true);
    }
  }
}

render(mode);
