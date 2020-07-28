HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    -- Return to the start screem of we press escape
    if love.keyboard.wasPressed('escape') then
        gSounds['wall-hit']:play()

        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("High Scores", 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])

    -- Iterate over all high score inices in our high score table

    for i = 1, 10 do
        local name = self.highScoresp[i].name or '----'
        local score = self.highScores[i].score or '----'

        -- Score number (1-10)
        local.graphics.printf(tostring(i).. '.', VIRTUAL_WIDTH / 4, 60 + i * 13, 50, 'left')

        -- Score name
        love.graphics.printf(name, VIRTUAL_WIDTH, 4 + 38, 60 + 1 * 13, 100, 'right')

        -- Score itself
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH/2, 60 + i * 13, 100, 'right')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press escape to return to main menu!", 
        0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end