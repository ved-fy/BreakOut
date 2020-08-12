-- Inherit from base state
PlayState = Class{__includes = BaseState}

-- Initialize paddle
function PlayState:enter(params)
    self.paddle = params.paddle
    self.ball = params.ball
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints

    -- Give ball random starting vellocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused then 
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return 
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end 

    -- Update paddle's position based on velocity
    self.paddle:update(dt)

    -- Update ball's position based on velocity
    self.ball:update(dt)

    -- Check for collision with paddle
    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        -- Tweak angle of bounce based on collision on paddle
        -- If we hit the paddle on the left side while we are moving towards left
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

        -- Else if we hit the paddle on the right side while we are moving right
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        -- Play paddle hit sound
        gSounds['paddle-hit']:play()
    end

    -- Detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        -- Only check collision if we are in play
        if brick.inPlay and self.ball:collides(brick) then

            -- Add to score
            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            -- Trigger the bricks hit function, which removes it from play
            brick:hit()

            -- If we have enough points, recover a point of health
            if self.score > self.recoverPoints then
                -- cant go above 3 health
                self.health = math.min(3, self.health + 1)

                -- multiply recover pointes by 2
                self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                -- Play recover sound
                gSounds['recover']:play()
            end

            -- Go to victory state if there are no more bricks left
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = self.ball
                })
            end

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
                self.ball.y = brick.y + 16
            end

            -- Slightly scale the y velocity to speed up the game
            self.ball.dy = self.ball.dy * 1.02
            -- Only allow colliding with 1 brick    
            break
        end
    end

    -- If ball goes below bounds, revert to serve state and decrease health
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()
    
        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                recoverPoints = self.recoverPoints
            })
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end
    
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
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

    -- Render particles
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- Pause text (if paused)
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Paused", 0, VIRTUAL_WIDTH/2 - 16, VIRTUAL_HEIGHT/2)
    end
end

