local Component   = require "models.scenes.Component"
local Image       = require "models.images.Image"
local SoundEffect = require "models.audio.SoundEffect"
---@class LevelButton
LevelButton       = {}

LevelButton.new   = function(name, enableAssetPath, disableAssetPath, hoverAssetPath, lockedAssetPath, finishedAssetPath, x, y, level, onclick, onEnter, onLeave)
    local levelButton = Component.new(name, x, y, 64, 64)

    setmetatable(levelButton, LevelButton)
    LevelButton.__index   = LevelButton

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local mouseIsOver     = false
    local wasOver         = false
    local mouseIsPressed  = false
    local active          = false
    local finished        = false

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local levelEnabled    = Image.new(levelButton.name .. "_levelEnabled", enableAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32)
    local levelDisabled   = Image.new(levelButton.name .. "_levelDisabled", disableAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32)
    local levelLocked     = Image.new(levelButton.name .. "_levelLocked", lockedAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32).hide()
    local levelHover      = Image.new(levelButton.name .. "_levelHover", hoverAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32).hide()
    local levelFinished   = Image.new(levelButton.name .. "_levelFinished", finishedAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32).hide()
    local soundEffect     = SoundEffect.new(levelButton.name .. "_soundEffect", "assets/ui/switch2.ogg", "static", false, false, configuration:getSoundVolume())
    local forbiddenEffect = SoundEffect.new(levelButton.name .. "_forbiddenEffect", "assets/ui/wrong.mp3", "static", false, false, configuration:getSoundVolume())

    levelButton.addComponent(levelDisabled)
    levelButton.addComponent(levelEnabled)
    levelButton.addComponent(levelLocked)
    levelButton.addComponent(levelHover)
    levelButton.addComponent(levelFinished)
    levelButton.addComponent(soundEffect)
    levelButton.addComponent(forbiddenEffect)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function levelButton.load()
        if tonumber(configuration:getLevel()) == tonumber(level) then
            levelEnabled.show()
            levelDisabled.hide()
            levelFinished.hide()
            active   = true
            finished = false
        elseif tonumber(configuration:getLevel()) > tonumber(level) then
            levelFinished.show()
            levelDisabled.hide()
            active   = false
            finished = true
        else
            levelEnabled.hide()
            levelDisabled.show()
            levelFinished.hide()
            active   = false
            finished = false
        end
    end

    ---@public
    function levelButton.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then
            return
        end
        local isDown     = love.mouse.isDown(1)
        local wasPressed = not isDown and mouseIsPressed
        mouseIsPressed   = isDown
        mouseIsOver      = levelButton.bounds.containsPoint(screenManager:ScaleUIValueX(mouseX), screenManager:ScaleUIValueY(mouseY))

        if not mouseIsOver then
            mouseIsPressed = false
            if wasOver and onLeave ~= nil then
                wasOver = false
                onLeave({ active = active, level = level })
            end
        end

        if not finished then
            if not mouseIsOver then
                if active then
                    levelEnabled.show()
                    levelHover.hide()
                else
                    levelDisabled.show()
                    levelLocked.hide()
                end
            elseif mouseIsOver and not isDown then
                if not wasOver and onEnter ~= nil then
                    onEnter({ active = active, level = level })
                    wasOver = true
                end
                if active then
                    levelHover.show()
                    levelEnabled.hide()
                else
                    levelLocked.show()
                    levelDisabled.hide()
                end
            end
        end

        if mouseIsOver and wasPressed then
            if active then
                soundEffect.play()
            else
                forbiddenEffect.play()
            end
            if (onclick ~= nil and active) then
                onclick({ active = active, level = level })
            end
        end
    end

    return levelButton
end

return LevelButton
