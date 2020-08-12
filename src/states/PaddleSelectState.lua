PaddleSelectState = Class {__includes = BaseState}

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
end

function PaddleSelectState:init()
    -- Paddle we have highlighted will be passed on to the start state
    self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.currentPaddle == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play() 
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentPaddle == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        gStateMachine:change('serve', {
            paddle = Paddle(self.currentPaddle),
            bricks = LevelMaker.createMap(32),
            health = 3,
            score = 0,
            highScores = self.highScores,
            level = 32,
            recoverPoints = 5000
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PaddleSelectState:render()
    -- Instructions
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select the paddle with left and right arrows!", 0, VIRTUAL_HEIGHT/4, 
    VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Enter to continue!", 0, VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH, 'center')

    -- Render left arrow and right arrow normally if we're higher than 1, else
    -- in a shadowy form to let us knmow w're as far left as we can go
    if (self.currentPaddle == 1) then
        love.graphics.setColor(0.156, 0.156, 0.156, 0.75)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 32, 
    VIRTUAL_HEIGHT - VIRTUAL_HEIGHT/3)

    -- Reset drawing color to full white for proper rendering 
    love.graphics.setColor(1, 1, 1, 1)

    if (self.currentPaddle == 4) then
        love.graphics.setColor(0.156, 0.156, 0.156, 0.75)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH /4 ,
    VIRTUAL_HEIGHT - VIRTUAL_HEIGHT/3)

    love.graphics.setColor(1, 1, 1, 1)

    -- Draw the paddles itself
    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)],
    VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4)
end