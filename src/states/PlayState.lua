-- Inherit from base state
PlayState = Class{__includes = BaseState}

-- Initialize paddle
function PlayState:init()
    -- Spawn paddle
    self.paddle = Paddle()

    -- Spawn ball
    self.ball = Ball(1)

    -- Give ball random velocity
    self.ball.dx = math.random(-100, 100)
    self.ball.dy = math.random(50, 100)

    -- Give ball position in center
    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42

    self.pause = false

    -- use the "static" createMao functin to generate bricks
    self.bricks = LevelMaker.createMap()
end

function PlayState:update(dt)
    if self.paused then 
        if love.keyboard.wasPressed('space') then
            self.paused = false
            ------ TODO : Add unpause sound
        else
            return 
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        -- TODO : Play pause sound
        return
    end 

    -- Update paddle's position based on velocity
    self.paddle:update(dt)

    -- Update ball's position based on velocity
    self.ball:update(dt)

    -- Check for collision with paddle
    if self.ball:collides(self.paddle) then
        self.ball.y= self.paddle.y - 8
        self.ball.dy = - self.ball.dy

         -- Tweak angle of bounce based on collision on paddle

        -- If we hit the paddle on the left side while we are moving towards left
        if self.ball.x < self.ball.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
        self.ball.dx = -50 + -(8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        
        -- Else if we hit the paddle on the right side while we are moving right
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
        self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        -- Play paddle hit sound
        gSounds['wall-hit']:play()
    end

   

    -- Detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        -- Only check collision if we are in play
        if brick.inPlay and self.ball:collides(brick) then
            -- Trigger bricks hit function
            brick:hit()

            -- collision code for bricks
            -- left edge; only check if we're moving right
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                -- flip x vellocity and reset the position outside of the brick
                self.ball.dx = - self.ball.dx
                self.ball.x = brick.x - 8

            -- right edge; only check if we are moving left
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                -- flip the x vellocity and reset position outside brick
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32

            -- top edge if no x collisions, always check
            elseif self.ball.y < brick.y then
                -- flip y velocity and reset the position outside of brick
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8

            -- bottom edge if no X collisions or top collisions last possibility
            else
                -- flip y velocity and reset position outside 
                self.ball.dy = -self.ball.dy
                self.ball.x = brick.y + 16
            end

            -- Slightly scale the y velocity to sepped uo the game
            self.ball.dy = self.ball.dy * 1.02
            -- Only allow colliding with 1 brick    
            break
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- Render paddle
    self.paddle:render()

    --Render ball
    self.ball:render()

    -- Render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- Pause text (if paused)
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Paused", 0, VIRTUAL_WIDTH/2 - 16, VIRTUAL_HEIGHT/2)
    end
end

