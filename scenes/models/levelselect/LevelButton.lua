local Component = require "models.scenes.Component"
local Image = require "models.images.Image"
local SoundEffect = require "models.audio.SoundEffect"
---@class LevelButton
LevelButton = {}

LevelButton.new = function(name, enableAssetPath, disableAssetPath, hoverAssetPath, lockedAssetPath, x, y, level, onclick, onEnter, onLeave)
    local levelButton =
        Component.new(
        name,
        {
            enableAssetPath = enableAssetPath,
            disableAssetPath = disableAssetPath,
            hoverAssetPath = hoverAssetPath,
            lockedAssetPath = lockedAssetPath,
            level = level,
            onclick = onclick,
            onEnter = onEnter,
            onLeave = onLeave,
            active = false,
            mouseIsOver = false,
            wasOver = false,
            mouseIsPressed = false
        },
        x,
        y,
        64,
        64
    )

    setmetatable(levelButton, LevelButton)
    LevelButton.__index = LevelButton

    local levelEnabled = Image.new(levelButton.name .. "_levelEnabled", levelButton.data.enableAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32)
    local levelDisabled = Image.new(levelButton.name .. "_levelDisabled", levelButton.data.disableAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32)
    local levelLocked = Image.new(levelButton.name .. "_levelLocked", levelButton.data.lockedAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32).hide()
    local levelHover = Image.new(levelButton.name .. "_levelHover", levelButton.data.hoverAssetPath, levelButton.bounds.x + 32, levelButton.bounds.y + 32).hide()
    local soundEffect = SoundEffect.new(levelButton.name .. "_soundEffect", "assets/ui/switch2.ogg", "static", false, false, configuration:getSoundVolume())
    local forbiddenEffect = SoundEffect.new(levelButton.name .. "_forbiddenEffect", "assets/ui/wrong.mp3", "static", false, false, configuration:getSoundVolume())

    levelButton.addComponent(levelDisabled)
    levelButton.addComponent(levelEnabled)
    levelButton.addComponent(levelLocked)
    levelButton.addComponent(levelHover)
    levelButton.addComponent(soundEffect)
    levelButton.addComponent(forbiddenEffect)

    if tonumber(configuration:getLevel()) >= tonumber(levelButton.data.level) then
        print(levelButton.name .. " level is enabled")
        levelEnabled.show()
        levelDisabled.hide()
        levelButton.data.active = true
    else
        print(levelButton.name .. " level is disabled")
        levelEnabled.hide()
        levelDisabled.show()
        levelButton.data.active = false
    end

    function levelButton.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then
            return
        end
        local isDown = love.mouse.isDown(1)
        local wasPressed = not isDown and levelButton.data.mouseIsPressed
        levelButton.data.mouseIsPressed = isDown
        levelButton.data.mouseIsOver = levelButton.bounds.containsPoint(mouseX, mouseY)

        if not levelButton.data.mouseIsOver then
            levelButton.data.mouseIsPressed = false
            if levelButton.data.wasOver and levelButton.data.onLeave ~= nil then
                levelButton.data.wasOver = false
                levelButton.data.onLeave({active = levelButton.data.active, level = levelButton.data.level})
            end
        end

        if not levelButton.data.mouseIsOver then
            if levelButton.data.active then
                levelEnabled.show()
                levelHover.hide()
            else
                levelDisabled.show()
                levelLocked.hide()
            end
        elseif levelButton.data.mouseIsOver and not isDown then
            if not levelButton.data.wasOver and levelButton.data.onEnter ~= nil then
                levelButton.data.onEnter({active = levelButton.data.active, level = levelButton.data.level})
                levelButton.data.wasOver = true
            end
            if levelButton.data.active then
                levelHover.show()
                levelEnabled.hide()
            else
                levelLocked.show()
                levelDisabled.hide()
            end
        end

        if levelButton.data.mouseIsOver and wasPressed then
            if levelButton.data.active then
                soundEffect.play()
            else
                forbiddenEffect.play()
            end
            if (levelButton.data.onclick ~= nil and levelButton.data.active) then
                levelButton.data.onclick({active = levelButton.data.active, level = levelButton.data.level})
            end
        end
    end

    return levelButton
end

return LevelButton
