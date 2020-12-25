# Advent of Code 2020

In Elixir!

## h/t to:

* Day 7: [@papey](https://github.com/papey/aoc/blob/master/2k20/aoc/lib/w2.ex)
* Day 10: Tribonacci hints on [r/adventofcode](https://www.reddit.com/r/adventofcode/)
* Day 13: Chinese Remainder Theorem hints on [r/adventofcode](https://www.reddit.com/r/adventofcode/), [@voltone](https://github.com/voltone?tab=repositories)'s elixir forum [comment](https://elixirforum.com/t/advent-of-code-2020-day-13/36180/6)
* Day 18: @mexicat's elixir forum [comment](https://elixirforum.com/t/advent-of-code-2020-day-18/36300/10)
* Day 23: Map hints on [r/adventofcode](https://www.reddit.com/r/adventofcode/)

##  Day 20 Walkthrough

### Assumptions

First, the following approach only works for square grids, i.e. 4, 9, 16, etc. tiles with 2x2, 3x3, 4x4, etc. sides.

Second, Assume that the given inputs are non-ambiguous, i.e. when it comes to rotating and flipping each tile, there is only one way to align two together.

With that in mind, try to visualize working backwards from the final alignment of tiles. Using the following example:

    abcdeeqrstt---+
    p   ff   uu   |
    o 1 gg 2 vv 5 | ...
    n   hh   ww   |
    mlkjiizzyxx---+
    mlkjiizzyxx---+
    y   oo   nn   |
    x 3 pp 4 mn 6 | ...
    w   qq   ll   |
    vutsrrhijkk---+
    |   ||   ||   |
    | 9 || 8 || 7 | ...
    |   ||   ||   |
    +---++---++---+
      .    .    .
      .    .    .
      .    .    .

We can assume that:

* Sides `efghi` for tiles 1 and 2 will pair with each other only
* Sides `izzyx` for tiles 2 and 4 will pair with each other only
* Sides `iopqr` for tiles 4 and 3 will pair with each other only
* Sides `mlkji` for tiles 3 and 1 will pair with each other only

As such, even if you get all permutations of tile 1's sides as such:

1. `abcde`
2. `edcba`
3. `efghi`
4. `ihgfe`
5. `mlkji`
6. `ijklm`
7. `aponm`
8. `mnopa`

You can assume that only 2 of the 8 permutations will align with tiles 2 and 3.

### Part 1

As such, solving for part 1 is a relatively simple exercise of generating the 8 permutations of all tiles, and seeing how many matches there are.

* For corners, there will be 2 matches.
* For sides, there will be 3 matches.
* For the insides, there will be 4 matches.

There will only be 4 tiles where there are 2 matches for each of their 8 possible sides.

To solve part 1 and also to aid in part 2, you should generate a mapping of each tile's neighbors.

Using the example above, it can be something like:

    tile 1 => [tile 2, tile 3] 
    tile 2 => [tile 1, tile 4, tile 5] 
    tile 3 => [tile 1, tile 4, tile 9]
    tile 4 => [tile 2, tile 3, tile 6, tile 8]

### Part 2

#### Forming the grid

Consider a row-based approach to piecing the tiles back together.

Let's start from the first row that has a corner tile. To get the second tile, just pick any one of its neighbors.

For the third tile, after tile 2 from the example above, you know there are only two options, tile 4 or 5. Since this is still along the sides, you should look for the tile that does not have four neighbors, i.e. an inside tile. Hence, you should pick tile 5.

Repeat until you have aligned the number of tiles for the side. For example, stop at 4 tiles if we are given a total of 16 tiles.

To generate the subsequent rows, you will need to find the starting tile for each of them. They will all be the last tile that is not used yet from the neighbors of the previous row's starting tile.

The final logic to implement is solving for all the inside tiles. Using the example above, we know we should pick tile 7 after tile 8 on the third row, because we can intersect the neighbors of tile 8 and tile 6 (the previous row's tile at the same column), and exclude tile 3 which is already used (in the previous row, at the previous column).

In psuedocode, the complete logic for forming a row is as such:

    While we have less than <n> tiles,
        How many neighbors are there for the previous row tile?
            If there are two (i.e. starting from the corners), 
                If this is the first row,
                    Pick any neighbor if we're at the first row, 
                Else this is the last row, so pick the other neighbor that was not the starting tile of the previous row.
            If there are three (i.e. the sides),
                If this is the first or last row, 
                    Pick the other neighbor that also does not have four neighbors of their own and is not the previous, previous tile,
                Else this is the left side, so pick the neighbor that has four neighbors of their own (we are going inside).
            If there are four (i.e. the insides),
                Find the intersection of the neighbors with the neighbors of the previous column tile, 
                    and exclude the tile that was on the previous row and column (i.e. diagonal of the current position).

You should be able to generate the complete grid. Let's move on to figuring out how to rotate/flip the tiles to actually have the contents aligned.

#### Rotating/flipping the tiles

Once the first two tiles are correctly aligned (by rotating and/or flipping both), you know that you should only rotate or flip the subsequent tiles to line up with the already aligned ones.

Alignment of two tiles is just to check if the sides of one tile/block (i.e. a series of tiles) is the same as the other tile.

Depending on your language or framework, you may need to handle the rotation/flipping 'by hand'. It helps to visualize that there are only 8 distinct ways of arranging a tile's contents:

    ab # Starting arrangement
    cd
    
    ba # Flip horizontal of starting arrangement
    dc
    
    cd # Flip vertical of starting arrangement
    ab
    
    ca # One clockwise rotation (90 degrees) from starting arrangement 
    db
    
    ac # Flip horizontal of one clockwise rotation
    bd
    
    db # Flip vertical of one clockwise rotation
    ca
    
    dc # Two clockwise rotations (180 degrees) from starting arrangement
    ba
    
    bd # Three clockwise rotations (270 degrees) from starting arrangement
    ac

For example, if you are modeling the tile contents as an array of strings, your transformation functions can be:

    flip_horizontal: For each row of the tile's content, reverse the string
    flip_vertical: Reverse the array, keeping the string contents intact
    rotate_clockwise: Depends on the array manipulation functions  

It should not be that computationally expensive to generate all eight ways and see which is the only way that will align with the given tile/block.

The last twist here is that even after all tiles within a row are aligned correctly, you need to align the rows too!

Thankfully, we only need to consider whether we need to flip horizontally or vertically, i.e. no need to perform rotations.

#### Removing the glue borders

We should have the complete grid with all the 'glue' borders. This is the most trivial step, by stepping throw each row/column and discarding the glue borders.

#### Counting the monsters by rotating/flipping the final grid

Similar to our approach for rotating tiles, we can assume that the monsters will only appear for one position.

Generate the eight possibilities of rotating/flipping the final grid, and iterate through blocks of 3x20 (rows, columns) to see if they match the regex for the monster.