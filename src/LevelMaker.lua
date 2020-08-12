LevelMaker = Class{}

-- Global patterns (used to make the entire map a certain shape)
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- Per-row patterns
SOLID = 1               -- All colors the same in the row
ALTERNATE = 2           -- Alternate colors
SKIP = 3                -- Skip every other block
NONE = 4                -- no blocks this row

function LevelMaker.createMap(level)
    local bricks = {}

    -- Randomly choose the number of rows
    local numRows = math.random(1, 5)

    -- Randomly choose the number of columns
    local numCols = math.random(7, 13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    -- Highest possibe spawned brick color in this level; ensure we dont go above 3
    local highestTier = math.min(3, math.floor(level / 5))

    -- Highest color of the highest tier
    local highestColor = math.min(5, level % 5 + 3)

    for y = 1, numRows do
        -- whether we want to enable skipping for this row
        local skipPattern = math.random(1, 2) == 1 and true or false

        -- whether we want to enable alternating colors for this raw
        local alternatePattern = math.random(1, 2) == 1 and true or false

        -- Choose 2 colors to alternate between
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier) 

        -- Used only when we want to skip a block, for skip pattern
        local skipFlag = math.random(2) == 1 and true or false

        -- Used only when we want to alternate a block, for alternate pattern
        local alternateFlag = math.random(2) == 1 and true or false

        -- Solid color we will use if we are not alternating
        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(0, highestTier)

        for x = 1, numCols do
            -- If skipping is turned on and we're on a skip iteration
            if skipPattern and skipFlag then
                -- Turn skipping off for the next iteration
                skipFlag = not skipFlag

                -- Lua doesnt have a continue statment, so this is the workaround
                goto continue
            else
                skipFlag = not skipFlag;
            end

            b = Brick(
                -- x-cordinate
                (x - 1)             -- Decriment x by 1 because tables are 1-indexed, cords are 0
                * 32                -- Multiply by 32, the brick width
                + 8                 -- The screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                + (13 - numCols) * 16,   -- left-side padding for when there are fewer than 13 columns

                -- y-cordingate
                y * 16              -- just use y * 16, since we need top padding anyway
            )

            
            -- If we're alternating, figure out which color/tier we're on
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            -- If not alternatePattern then
            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end

            table.insert(bricks, b)

            --Lua version of the continue statement
            ::continue::
        end
    end

    if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end 