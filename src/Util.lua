

function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spriteSheet = {}

    for y = 0, sheetHeight - 1  do
        for x = 0, sheetWidth - 1 do
            spriteSheet[sheetCounter] = 
                love.graphics.newQuad(x * tileWidth, y * tileHeight, 
                    tileWidth,tileHeight, atlas:getDimensions())
                sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end

-- Utility function to slice tables
function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function GenerateQuadsPaddle(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- Smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, 
            atlas:getDimensions())
        counter = counter + 1
        -- Medium 
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- Large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, 
            atlas:getDimensions())
        counter = counter + 1
        -- Huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16,
            atlas:getDimensions())
        counter = counter + 1

        -- Prepare for the location of next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end

function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    -- Getting the first row
    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end
    
    x = 96
    y = 56

    -- Getting second row
    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    end

    return quads
end 

function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end