Brick = Class{}

paletteColors = {
    -- blue
    [1] = {
        ['r'] = 0.388,
        ['g'] = 0.607,
        ['b'] = 1
    },
    -- green
    [2] = {
        ['r'] = 0.415,
        ['g'] = 0.745,
        ['b'] = 0.184
    },
    -- red
    [3] = {
        ['r'] = 0.850,
        ['g'] = 0.341,
        ['b'] = 0.388
    },
    -- purple
    [4] = {
        ['r'] = 0.843,
        ['g'] = 0.482,
        ['b'] = 0.729
    },
    -- gold
    [5] = {
        ['r'] = 0.984,
        ['g'] = 0.949,
        ['b'] = 0.211
    }
}

function Brick:init(x, y)
    self.x = x
    self.y = y

    self.tier = 0
    self.color = 1

    self.width = 32
    self.height = 16

    -- used to determine whether this brick should be rendered or not
    self.inPlay = true

    -- Particle system belonging to the brick, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- Last between 0.5-1 seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- Give it an acceleration between X1, Y1 and X2, Y2 (0, 0) and (80, 80) here generaly gives downwards
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- Spread of particels; normal looks more natural than uniform, which is clumpy; 
    -- Numbers are amount of standard deviation away in X and Y axis
    self.psystem:setEmissionArea('normal', 10, 10)
end

function Brick:hit()
    -- Set the particle system to interpolate between 2 colors; in this case
    -- we give it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)

    self.psystem:setColors(
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        55 * (self.tier + 1),
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0
    )
    self.psystem:emit(64)

    gSounds['brick-hit']:stop()
    gSounds['brick-hit']:play()
    
    -- If we're at a higher tier than the base, we need to go down a tier
    -- If we're already at the lowest tier, else jusy go down a color
    if self.tier > 0 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        -- If we're in the first tier and the base color, remove the brick
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    -- If brick is destroyed play another sound
    if not self.inPlay then
        gSounds['brick-destroyed']:stop()
        gSounds['brick-destroyed']:play()
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
        -- multiply the color by 4 to get the color and then add tier to get the correct brick
        gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
        self.x, self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end

