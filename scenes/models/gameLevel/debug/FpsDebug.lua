local Component = require "models.scenes.Component"
local Text      = require("models.texts.Text")
---@class FpsDebug
FpsDebug        = {}

FpsDebug.new    = function()
    local fpsDebug = Component.new(
            "FpsDebug",
            {
                frameCount  = 0,
                elapsedTime = 0,
                fpsDebug    = 0
            }
    )

    setmetatable(fpsDebug, FpsDebug)
    FpsDebug.__index = FpsDebug

    local text       = Text.new("fpsDebug-text", "No enough data", "center", "top", 20, 180, nil, nil, nil, nil, fpsDebug.color)

    fpsDebug.addComponent(text)

    ---@public
    function fpsDebug.update(dt)
        fpsDebug.data.frameCount  = fpsDebug.data.frameCount + 1
        fpsDebug.data.elapsedTime = fpsDebug.data.elapsedTime + dt
        if (fpsDebug.data.elapsedTime > 1) then
            fpsDebug.data.elapsedTime = 0
            text:setContent("FPS: " .. fpsDebug.data.frameCount)
            fpsDebug.data.frameCount = 0
        end
    end

    ---@public
    function fpsDebug.draw()
        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(10), screenManager:ScaleValueY(170), screenManager:ScaleValueX(420), screenManager:ScaleValueY(35))
        love.graphics.setColor(1, 1, 1, 1)
    end

    return fpsDebug
end

return FpsDebug
