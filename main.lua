require 'src/Dependencies'

function love.load()
    -- Disabling filtering of pixals for crisp 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- RNG seed
    math.randomseed(os.time())

    -- Title
    love.window.setTitle("Breakout")

    -- Loading fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    -- Loadinig graphics we will be using
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    -- Genaerated quades to display part of a texture and not the entire thing
    gFrames = {
        ['paddles'] = GenerateQuadsPaddle(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['powerups'] = GenerateQuadsPowerUps(gTextures['main'])
    }

    -- Set up table for sound effects
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['brick-hit'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-destroyed'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    -- Initializing virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Initializing a state machine
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['paddle-select'] = function() return PaddleSelectState() end,
        ['high-scores'] = function() return HighScoreState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['enter-highscore'] = function() return EnterHighScoreState() end
    } 
    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    -- Table used to store keys that are pressed this frame. Love doesnt allow us to check inputs
    -- from other fucntions
    love.keyboard.keysPressed = {}
end

-- Function called when we resize our window
function love.resize(w, h)
    push:resize(w, h)
end

-- Updates function passing in delta time
function love.update(dt)
    -- Passing in dt to the state machine we are currently in
    gStateMachine:update(dt)

    -- Reset keys pressed every frame
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    -- Add to the table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

-- Custom function that will test for individual keystroke outside of the default 'keyPressed' callback
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- Render function
function love.draw()
    -- Begin drawing with push
    push:apply('start')

    -- Render the current state machine
    gStateMachine:render()

    -- Display FPS
    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS : ' ..tostring(love.timer.getFPS(), 5, 5))
end

function renderHealth(health)
    -- Start of our health rendering
    local healthX = VIRTUAL_WIDTH - 100

    -- Render health left
    for i = 1, health do 
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- Render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

-- Loads high scores from a .lst file, saved in Love2D's default save directory
function loadHighScores()
    love.filesystem.setIdentity('breakout')

    -- If the file doesnt exist, initialize it with some default scores
    dir = love.filesystem.getSaveDirectory()
    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'VED\n'
            scores = scores .. tostring(i * 10000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- Flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- Initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end
    -- Iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- Flip the name flag
        name = not name
    end

    return scores       
end