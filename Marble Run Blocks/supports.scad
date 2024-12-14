include <../libraries/BOSL2/std.scad>
include <./tools.scad>

// Build mode
mode = 1; // [1:Corner,2:Full block,3:Steps,4:Corner with steps,5:Double full block]

module load_support()
{
    import(support_single_filename);
}

/**
 * Cutout for the top of the block.
 */
module cutout_top()
{
    y_offset = half_block_height - corner_height;
    down(y_offset) difference()
    {
        load_support();

        cube([ block_width, block_width, y_offset ], anchor = BOTTOM);
    }
}

/**
 * Cutout for the bottom of the block.
 */
module cutout_bottom()
{
    difference()
    {
        load_support();

        up(peg_socket_height) cube([ block_width, block_width, half_block_height ], anchor = BOTTOM);
    }
}

/**
 * Cutout between the top and bottom of the block.
 */
module cutout_inbetween()
{
    y_offset = half_block_height - corner_height;

    down(peg_socket_height) difference()
    {
        load_support();
        echo(y_offset);
        up(y_offset) cutout_top();
        cutout_bottom();
    }
}

/**
 * Make an extended support block.
 */
module make_extended_support(wanted_block_height)
{
    assert(wanted_block_height % half_block_height == 0);

    union()
    {
        base_height = half_block_height - corner_height - peg_socket_height;
        wanted_height = wanted_block_height - corner_height - peg_socket_height;

        zscale_factor = wanted_height / base_height;
        union()
        {
            cutout_bottom();
            up(4)
            {
                zscale(zscale_factor) cutout_inbetween();
                up(wanted_height) cutout_top();
            }
        }
    }
}

module make_full_block()
{
    make_extended_support(block_height);
}

if (mode == 1)
{
    load_support();
    left(block_width)
    {
        load_support();
        fwd(block_width)
        {
            load_support();
        }
    }
}
else if (mode == 2)
{
    make_full_block();
}
else if (mode == 3)
{
    load_support();
    left(block_width)
    {
        make_full_block();
    }
}
else if (mode == 4)
{
    load_support();
    left(block_width)
    {
        make_full_block();
        fwd(block_width)
        {
            make_extended_support(block_height * 1.5);
        }
    }
}
else if (mode == 5)
{
    make_full_block();
    left(block_width)
    {
        make_full_block();
    }
}