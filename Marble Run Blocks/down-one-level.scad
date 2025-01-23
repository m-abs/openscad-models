include <../libraries/BOSL2/std.scad>
include <./tools.scad>

mode = 3; // [1:Top, 2:Middle, 3:Bottom, 4:Full]

// Module: marbleRunPeg()
// Description: Make a peg for the top of a Marble Run Block.
module marbleRunPeg()
{
    keep() position(TOP) cuboid([ peg_width, peg_width, peg_height ], chamfer = 0.25, edges = EDGES_TOP_AND_SIDES);
}

// Module: marbleRunPegs()
// Description: Make pegs for the top of a Marble Run Block.
// Assumes anchor = CENTER for the block.
// Arguments:
//   bHeight: The height of the block - needed for alignment.
module marbleRunTopPegs(bHeight)
{
    for (i = [ -1, 1 ])
    {
        for (j = [ -1, 1 ])
        {
            left(peg_offset * i) back(peg_offset * j) marbleRunPeg();
        }
    }
}

// Module: marbleRunPegSocketCutout()
// Description: Make a peg socket cutout for the bottom of a Marble Run Block.
module marbleRunPegSocketCutout()
{
    remove() position(BOTTOM) cuboid([ peg_socket_width, peg_socket_width, peg_socket_height ], anchor = BOTTOM,
                                     chamfer = -block_outer_chamfer, edges = BOTTOM);
}

// Module: marbleRunAllFourPegSocketsCutout()
// Description: Make peg socket cutouts for the bottom of a Marble Run Block.
// Assumes anchor = CENTER for the block.
module marbleRunAllFourPegSocketsCutout()
{
    for (i = [ -1, 1 ])
    {
        for (j = [ -1, 1 ])
        {
            left(peg_socket_offset * i) back(peg_socket_offset * j) marbleRunPegSocketCutout();
        }
    }
}

// Module: marbleRunBottomCutout()
// Description: Make a cutout square in the middle of the bottom of a Marble Run Block.
module marbleRunBottomCutout()
{
    remove() position(BOTTOM) cuboid([ middle_cutout_width, middle_cutout_width, middle_cutout_height ],
                                     anchor = BOTTOM, chamfer = -block_outer_chamfer, edges = BOTTOM);
}

// Module: marbleRunBlock()
// Description: Make a Marble Run Block.
// Arguments:
//   bHeight: The desired height of the block. Usually half_block_height, block_height or double_block_height.
//   cutoutMiddlePiece: Should bottom middle be cut out?
module marbleRunBlock(bHeight, cutoutMiddlePiece = true)
{
    assert(bHeight % half_block_height == 0, "Block height must be a multiple of 20 mm");
    diff()
    {
        cuboid([ block_width, block_width, bHeight ], anchor = BOTTOM, chamfer = block_outer_chamfer)
        {
            marbleRunTopPegs();

            if (cutoutMiddlePiece)
            {
                marbleRunBottomCutout();
            }

            marbleRunAllFourPegSocketsCutout();

            children();
        }
    }
}

module render(mode)
{
    shape = [rect([ tunnel_width, tunnel_width ], rounding = 9.5, $fn = 160)];

    bHeight = block_height;
    cutoutMiddlePiece = true;
    sweepPosition = TOP;

    topPieceTForm = [for (a = [90:-5:0]) xrot(a, cp = [ 0, -20 ])];
    bottomPieceTForm = [for (a = [0:5:90]) yrot(a, cp = [ -20, 0 ])];

    if (mode == 1)
    {
        cutoutMiddlePiece = false;
        tForms = topPieceTForm;
        sweepPosition = TOP;

        marbleRunBlock(block_height, false)
        {
            remove() position(TOP) down(block_height) sweep(shape, tForms, closed = false, caps = true);
        }
    }
    else if (mode == 2)
    {
        cutoutMiddlePiece = false;
        sweepPosition = CENTER;

        marbleRunBlock(block_height, false)
        {
            remove() position(CENTER) cuboid([ tunnel_width, tunnel_width, block_height + 2 ], rounding = 9.5,
                                             except = [ TOP, BOTTOM ], $fn = 160);
        }
    }
    else if (mode == 3)
    {
        tForms = bottomPieceTForm;
        sweepPosition = TOP;

        marbleRunBlock(block_height)
        {
            remove() position(TOP) sweep(shape, tForms, closed = false, caps = true);
        }
    }
    else if (mode == 4)
    {
        tForms = concat(topPieceTForm, bottomPieceTForm);
        bHeight = double_block_height;
        sweepPosition = CENTER;

        marbleRunBlock(double_block_height)
        {
            remove() position(CENTER) #sweep(shape, tForms, closed = false, caps = true);
        }
    }
}

render(mode);