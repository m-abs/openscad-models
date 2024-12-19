// This is a reversal of the Start Block. it is meant to let you go straight down one level to a start block.

include <./tools.scad>

difference()
{
    import(start_block_filename);

    corner_width = 7;
    corner_height = block_height + pegs_height;
    for (i = [ 1, -1 ])
    {
        for (j = [ 1, -1 ])
        {
            left((block_width - corner_width + 0.1) / 2 * i) fwd((block_width - corner_width) / 2 * j)
                up(corner_height / 2) cube([ corner_width, corner_width, corner_height ], center = true);
        }
    }
}
up(5) cube([ 25, 25, 10 ], center = true);

up(block_height) yrot(180)
{
    intersection()
    {
        import(start_block_filename);

        corner_width = 7;
        corner_height = block_height + pegs_height;
        for (i = [ 1, -1 ])
        {
            for (j = [ 1, -1 ])
            {
                left((block_width - corner_width + 0.1) / 2 * i) fwd((block_width - corner_width) / 2 * j)
                    up(corner_height / 2) cube([ corner_width, corner_width, corner_height ], center = true);
            }
        }
    }
}