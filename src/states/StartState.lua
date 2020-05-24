-- __include meanes we are inheriting
StartState = Class{__includes = BaseState}

-- whenever we are highlighting "Start" or "High Scores"
local highlighted = 1

function StartState:update(dt)
    -- Toggle highlighted option if we press arrow keys
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['select']:play()
    end

    -- Confirm whichever oprion we have selected to change screens
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- TODO : Play confirm sound

        if highlighted == 1 then
            gStateMachine:change('serve', {
                paddle = Paddle(1),
                bricks = LevelMaker.createMap(),
                health = 3,
                score = 0
            })

    -- We no longer have this gloabaly so included here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end 

function StartState:render()
     -- title
     love.graphics.setFont(gFonts['large'])
     love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3,
         VIRTUAL_WIDTH, 'center')
     
     -- instructions
     love.graphics.setFont(gFonts['medium'])
 
     -- if we're highlighting 1, render that option blue
     if highlighted == 1 then
         love.graphics.setColor(0, 255, 255, 255)
     end
     love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70,
         VIRTUAL_WIDTH, 'center')
 
     -- reset the color
     love.graphics.setColor(255, 255, 255, 255)
 
     -- render option 2 blue if we're highlighting that one
     if highlighted == 2 then
         love.graphics.setColor(0, 255, 255, 255)
     end
     love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90,
         VIRTUAL_WIDTH, 'center')
 
     -- reset the color
     love.graphics.setColor(255, 255, 255, 255)
end
