GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- See if score was higher than any scores in highscore table
        local isHighScore = false;

        -- Keep track of what highscore we want to overrite, if any
        local scoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
               scoreIndex = i
               isHighScore = true 
            end
        end

        if isHighScore then
            gSounds['high-score']:play()
            gStateMachine:change('enter-highscore', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = scoreIndex
            })
        else
            gStateMachine:change('start', {
                highScores = self.highScores
            })
        end
    end
    
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('FINAL SCORE: ' ..tostring(self.score), 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
end