// The Grid2x2 is a bit difficult to place for a child, so this script
// generates a build plate with multiple Grid2x2 blocks on it.

// The Grid2x2 is 60x60mm
// The attached blocks (the 2x2 pegs) are 20x20mm
// and the connection between the blocks is 20mm.

// If we offset the blocks by 40mm, the attached blocks will overlap
// and we can extend the grid in both directions.

x_repeats = 2;
y_repeats = 3;
grid_offset = 40;

grid_width = 60;

module buildPlate()
{
    union()
    {
        for (x = [1:x_repeats])
        {
            for (y = [1:y_repeats])
            {
                x_offset = (x - 1) * grid_offset + grid_width / 2;
                y_offset = (y - 1) * grid_offset + grid_width / 2;
                translate([ x_offset, y_offset ])
                {
                    import("MarbleRunBlocks-Grid2x2.stl");
                }
            }
        }
    }
}

buildPlate();