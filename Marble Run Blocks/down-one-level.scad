include <../libraries/BOSL2/std.scad>
include <./tools.scad>

block_outer_chamfer = 0.5;

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

marbleRunBlock(double_block_height)
{
    shape = [rect([ tunnel_width, tunnel_width ], rounding = 9.5, anchor = CENTER, $fn = 160)];

    tForms = [
        for (a = [90:-5:0]) xrot(a, cp = [ 0, -20 ]),
        for (a = [0:5:90]) yrot(a, cp = [ -20, 0 ]),
        move([ -20, 0, -20 ]) * yrot(90),
    ];

    remove() position(CENTER) sweep(shape, tForms, closed = false, caps = true);
}

/*
tForms = [
    for (a = [90:-5:0]) xrot(a, cp = [ 0, -20 ]),
    for (a = [0:5:90]) yrot(a, cp = [ -20, 0 ]),
    move([ -20, 0, -20 ]) * yrot(90),
];

shape = rect([ tunnel_width + 5, tunnel_width + 5 ], rounding = 9.5 + 2.5, anchor = CENTER, $fn = 160);
shape2 = rect([ tunnel_width, tunnel_width ], rounding = 9.5, anchor = CENTER, $fn = 160);
sweep([ shape2, shape ], tForms, closed = false, caps = true, $fn = 160); */

/* cuboid([ support_column_width, support_column_width, half_block_height ], anchor = CENTER,
       chamfer = block_outer_chamfer); */