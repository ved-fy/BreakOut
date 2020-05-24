LevelMaker = Class{}

function LevelMaker.createMap(level)
    local bricks = {}

    -- Randomly choose the number of rows
    local numRows = math.random(1, 5)

    -- Randomly choose the number of columns
    local numCols = math.random(7, 13)

    -- Lay out bricks such that they touch each other and fill the place
    for y = 1, numRows do
        for x = 1, numRows do
            b = Brick(
                -- x cordinate
                (x - 1)                 -- decrement x by 1 because tables are 1-indexed, cords are 0
                * 32                    -- multiply by 32, the brick width
                + 8                     -- Screen should have 8 pixels of padding, we can fit 13 cols + 16 pixels in total
                + (13 - numCols) * 16,   -- leftside padding for when there are fewer than 13 columns

                -- y cordinate
                y * 16                  -- just use y * 16
            )

            table.insert(bricks, b)
        end
    end

    return bricks
end