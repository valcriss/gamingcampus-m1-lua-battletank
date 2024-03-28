local Text = require("models/texts/Text")
---@class Fps
Fps = {}

Fps.new = function(color --[[optional]])
    color = color or {r = 1, g = 1, b = 1, a = 1}
    local fps = {
        frameCount = 0,
        totalFrameCoun = 0,
        elaspedTime = 0,
        fps = 0,
        visible = false,
        color = color
    }

    setmetatable(fps, Fps)
    Fps.__index = Fps

    local text = Text.new(fps.color)

    function fps:load()
        text:load()
    end

    ---@public
    function fps:update(dt)
        if not fps.visible then
            return
        end
        fps.frameCount = fps.frameCount + 1
        fps.elaspedTime = fps.elaspedTime + dt
        if (fps.elaspedTime > 1) then
            fps.elaspedTime = 0
            fps.fps = fps.frameCount
            fps.frameCount = 0
        end
    end

    ---@public
    function fps:draw()
        if not fps.visible then
            return
        end
        text:draw(10, 10, "FPS: " .. fps.fps)
    end

    ---@public
    function fps:unload()
        text:unload()
    end

    function fps:show()
        fps.visible = true
    end

    function fps:hide()
        fps.visible = false
    end

    function fps:toogle()
        if fps.visible then
            fps:hide()
        else
            fps:show()
        end
    end

    return fps
end

return Fps
