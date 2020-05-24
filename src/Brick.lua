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
    gSounds['brick-hit']:play()
    self.inPlay = false
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
        -- multiply the color by 4 to get the color and then add tier to get the correct brick
        gFrames['bricks'][1 + ((self.color - 1)*4) + self.tier],
        self.x, self.y)
    end
end

