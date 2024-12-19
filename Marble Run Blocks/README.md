# Marble run blocks - extras

These are extras for Marble Run Blocks by [WabbyStudio](https://cults3d.com/en/users/WabbyStudio/3d-models).

* [Marble Run Blocks - Starter pack](https://cults3d.com/en/3d-model/game/marble-run-blocks-starter-pack)
* [Marble Run Blocks - Extension pack](https://cults3d.com/en/3d-model/game/marble-run-blocks-extension-pack)
* [Marble Run Blocks - Medieval Castle pack](https://cults3d.com/en/3d-model/game/marble-run-blocks-medieval-castle-pack)

You won't find the models for the blocks here, you'll have to buy those yourself. They are well worth the price.

What you'll find here are extras that I made for myself.

## Models

### Extended build plate

The standard `Grid2x2` makes is more difficult to place the blocks, so I made larger version.

You need to copy the `MarbleRunBlocks-Grid2x2.stl`-file from the Starter pack into this folder.

When you open `extended-build-plate.scad` in OpenSCAD and set how mean repeats you want along the x and y axis. Render and export to STL.

In my set I printed two 3 by 2 and two 3 by 4.

### Custom end block

I had some issues with the standard end block. It is very big 4 by 4 and it doesn't have bottom, which limits how you can place it.

So with `custom-end-block.scad` you can create new end blocks or add a bottom to the original 4 by 4 end block.

To use this, you need to copy three files from the Starter pack.

* `MarbleRunBlocks-SupportSimple.stl`
* `MarbleRunBlocks-SupportDouble.stl`
* `MarbleRunBlocks-End.stl`

In OpenSCAD you can use the Customizer to select the size of the end block and add a bottom to it.
Render and export to STL.

### More support blocks

The standard support blocks from both the starter and castle packs don't give enough stability for taller builds, so I added some more.

Use `supports.scad` adds more support blocks.

To use this you need `MarbleRunBlocks-SupportSimple.stl` from the starter pack.

There are 8 variations for now.

1. Corner - a simple corner.
2. Full block - a 40x40x42 support block.
3. Steps - a step support block 1x 40x40x22 followed by a full block.
4. Corner with steps - Step around a corner. (Not very useful at the moment).
5. Double full block - 2x full support blocks.
6. Reverse steps - Similar to steps but the support blocks align on the top.
7. L - A longer corner piece shaped like a L.
8. Reverse L - Mirrored L piece.

### Going down

Send the marble straight down. It is meant to be placed on a start block.
This can be used to get the marble down to the level below and turn at the same time.

To use this you need the `MarbleRunBlocks-Start.stl` from the starter pack.

Open `going-down.scad` in OpenSCAD, render and export. There are no settings.
