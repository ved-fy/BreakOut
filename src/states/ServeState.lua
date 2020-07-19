ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    -- Grab paddle state from the params
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score

    -- Init new ball
    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    -- Have the ball track the player
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4;
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Pass in all the important state info to the play state
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end