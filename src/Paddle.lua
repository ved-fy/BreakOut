Paddle = Class{}

function Paddle:init()
    self.x = VIRTUAL_WIDTH / 2 - 32;
    self.y = VIRTUAL_HEIGHT - 32

    -- Starting vellocity 
    self.dx = 0

    -- Starting dimention
    self.width = 64
    self.height = 16

    -- Skin is used to change the color of the paddle and offset us to the
    -- gPaddle skins
    self.skin = 1

    -- The size varient; default 2
    self.size = 2
end 

function Paddle:update(dt)
    -- Keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- Boundary constraints
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

-- Render the paddle
function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
    self.x, self.y)
end