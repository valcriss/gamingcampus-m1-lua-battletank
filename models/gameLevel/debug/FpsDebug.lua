local DebugItem = require "models.gameLevel.debug.DebugItem"
---@class FpsDebug
FpsDebug        = {}

FpsDebug.new    = function()
    local fpsDebug = DebugItem.new("FpsDebug")

    setmetatable(fpsDebug, FpsDebug)
    FpsDebug.__index = FpsDebug

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function fpsDebug.innerUpdate(_)
        fpsDebug.setText("FPS: " .. love.timer.getFPS())
    end

    return fpsDebug
end

return FpsDebug
