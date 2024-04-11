local DebugItem = require "scenes.models.gameLevel.debug.DebugItem"
---@class FpsDebug
FpsDebug        = {}

FpsDebug.new    = function()
    local fpsDebug = DebugItem.new("FpsDebug")

    setmetatable(fpsDebug, FpsDebug)
    FpsDebug.__index = FpsDebug

    ---@public
    function fpsDebug.innerUpdate(_)
        fpsDebug.setText("FPS: " .. love.timer.getFPS())
    end

    return fpsDebug
end

return FpsDebug
