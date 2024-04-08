local DebugItem   = require "scenes.models.gameLevel.debug.DebugItem"

---@class ViewPortDebug
ViewPortDebug     = {}

--- @param gameManager GameManager
ViewPortDebug.new = function(gameManager)
    local viewPortDebug = DebugItem.new("ViewPortDebug")

    setmetatable(viewPortDebug, ViewPortDebug)
    ViewPortDebug.__index = ViewPortDebug

    -- ---------------------------------------------
    -- Protected Functions
    -- ---------------------------------------------
    ---@protected
    function viewPortDebug.innerUpdate(_)
        viewPortDebug.setText(
                  "Viewport.getRealBounds   : " .. gameManager.getViewport().getRealBounds().toString() .. "\n" ..
                        "Viewport.getRealPosition : " .. gameManager.getViewport().getRealPosition().toString() .. "\n" ..
                        "Viewport.getRenderBounds : " .. gameManager.getViewport().getRenderBounds().toString()
        )
    end

    return viewPortDebug
end

return ViewPortDebug
