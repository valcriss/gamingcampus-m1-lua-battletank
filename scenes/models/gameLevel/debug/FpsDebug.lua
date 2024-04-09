local DebugItem = require "scenes.models.gameLevel.debug.DebugItem"
---@class FpsDebug
FpsDebug        = {}

FpsDebug.new    = function()
    local fpsDebug = DebugItem.new("FpsDebug",
                                   nil,
                                   {
                                       frameCount  = 0,
                                       elapsedTime = 0,
                                       fpsDebug    = 0
                                   }
    )

    setmetatable(fpsDebug, FpsDebug)
    FpsDebug.__index = FpsDebug

    ---@public
    function fpsDebug.innerUpdate(dt)
        fpsDebug.data.frameCount  = fpsDebug.data.frameCount + 1
        fpsDebug.data.elapsedTime = fpsDebug.data.elapsedTime + dt
        if (fpsDebug.data.elapsedTime > 1) then
            fpsDebug.data.elapsedTime = 0
            fpsDebug.setText("FPS: " .. fpsDebug.data.frameCount)
            fpsDebug.data.frameCount = 0
        end
    end

    return fpsDebug
end

return FpsDebug
