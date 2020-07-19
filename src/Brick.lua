Brick = Class{}

function Brick:init(x, y)
    self.x = x
    self.y = y

    self.tier = 0
    self.color = 1

    self.width = 32
    self.height = 16

    -- used to determine whether this brick should be rendered or not
    self.inPlay = true
end

function Brick:hit()
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

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
        -- multiply the color by 4 to get the color and then add tier to get the correct brick
        gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
        self.x, self.y)
    end
end

