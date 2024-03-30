local Text = require("models/texts/Text")
---@class Fps
Fps        = {}

Fps.new    = function(name, x, y, color --[[optional]])
    color     = color or { r = 1, g = 0, b = 0, a = 1 }
    local fps = Component.new(
            name,
            {
                frameCount  = 0,
                elapsedTime = 0,
                fps         = 0,
                visible     = false,
                color       = color
            },
            x,
            y,
            nil,
            nil,
            nil,
            nil,
            color
    )

    setmetatable(fps, Fps)
    Fps.__index = Fps

    local text  = Text.new("fps-text", "No enough data", "center", "top", 10, 10, nil, nil, nil, nil, fps.color)

    fps.addComponent(text)

    ---@public
    function fps.update(dt)
        fps.data.frameCount  = fps.data.frameCount + 1
        fps.data.elapsedTime = fps.data.elapsedTime + dt
        if (fps.data.elapsedTime > 1) then
            fps.data.elapsedTime = 0
            text:setContent("FPS: " .. fps.data.frameCount)
            fps.data.frameCount = 0
        end
    end

    return fps
end

return Fps
