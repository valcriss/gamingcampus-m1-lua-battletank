local Scene = require "models.scenes.Scene"
local Image = require "models.images.Image"
local Text = require "models.texts.Text"

---@class FirstScene: Scene
local FirstScene = {}

---@param name string
---@param order number
FirstScene.new = function(name, order --[[optional]])
    order = order or 0
    local firstScene = Scene:new(name, order)
    setmetatable(firstScene, FirstScene)
    FirstScene.__index = FirstScene

    -- Classe Properties
    local image = Image.new("assets/playerShip3_red.png")
    local sceneName = Text.new()
    local helperText = Text.new()
    local quitText = Text.new()
    local rotation = 0

    -- Classe functions

    function firstScene:load()
        image:load()
        sceneName:load()
        helperText:load()
        quitText:load()
    end

    function firstScene:update(dt)
        rotation = rotation + (30 * dt)
    end

    function firstScene:draw()
        image:draw(screenManager.calculateCenterPointX(), screenManager.calculateCenterPointY(), rotation)
        sceneName:draw(10, 10, "First Scene")
        helperText:draw(10, 720, "Press X to go to the next scene")
        quitText:draw(10, 740, "Press Escape to quit the game")
    end

    function firstScene:unload()
        image:unload()
        sceneName:unload()
        helperText:unload()
        quitText:unload()
    end

    function love.keypressed(key, _, _)
        if key == "x" then
            scenesManager:removeScene(firstScene)
            scenesManager:addScene(SecondScene.new("secondScene", 0))
        end
        if key == "escape" then
            love.event.quit()
        end
    end

    return firstScene
end

return FirstScene
