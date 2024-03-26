local Scene = require "models.scenes.Scene"
local Image = require "models.images.Image"
local Text = require "models.texts.Text"

---@class SecondScene: Scene
SecondScene = {}

---@param name string
---@param order number
SecondScene.new = function(name, order --[[optional]])
    order = order or 0
    local secondScene = Scene:new(name, order)

    setmetatable(secondScene, SecondScene)
    SecondScene.__index = SecondScene

    -- Classe Properties
    local image = Image.new("assets/playerShip2_green.png")
    local sceneName = Text.new()
    local helperText = Text.new()
    local quitText = Text.new()
    local rotation = 0

    -- Classe functions
    function secondScene:load()
        image:load()
        sceneName:load()
        helperText:load()
        quitText:load()
    end

    function secondScene:update(dt)
        rotation = rotation + (10 * dt)
    end

    function secondScene:draw()
        image:draw(screenManager.calculateCenterPointX(), screenManager.calculateCenterPointY(), rotation)
        sceneName:draw(20, 15, "Second Scene")
        helperText:draw(20, 720, "Press X to go to the next scene")
        quitText:draw(20, 740, "Press Escape to quit the game")
    end

    function secondScene:unload()
        image:unload()
        sceneName:unload()
        helperText:unload()
        quitText:unload()
    end

    function love.keypressed(key, scancode, isrepeat)
        if key == "x" then
            scenesManager:removeScene(secondScene)
            scenesManager:addScene(FirstScene.new("firstScene", 0))
        end
        if key == "escape" then
            love.event.quit()
        end
    end

    return secondScene
end

return SecondScene
