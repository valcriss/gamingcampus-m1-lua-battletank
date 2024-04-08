local Component   = require "models.scenes.Component"
local BitmapText  = require "models.texts.BitmapText"

---@class ViewPortDebug
ViewPortDebug     = {}

--- @param gameManager GameManager
ViewPortDebug.new = function(gameManager)
    local viewPortDebug = Component.new("ViewPortDebug")

    setmetatable(viewPortDebug, ViewPortDebug)
    ViewPortDebug.__index = ViewPortDebug

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local debug           = BitmapText.new("ViewPortDebug_Debug", "assets/debug/courier-14.fnt", "", "left", "top", 20, 20, nil, nil, 0, 1)
    viewPortDebug.addComponent(debug)

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function viewPortDebug.update(_)
        debug.setContent(
                "Viewport.getRealBounds      : " .. gameManager.getViewport().getRealBounds().toString() .. "\n" ..
                        "Viewport.getRealPosition    : " .. gameManager.getViewport().getRealPosition().toString() .. "\n" ..
                        "Viewport.getRenderBounds    : " .. gameManager.getViewport().getRenderBounds().toString()
        )
    end

    ---@public
    function viewPortDebug.draw()
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(10), screenManager:ScaleValueY(10), screenManager:ScaleValueX(420), screenManager:ScaleValueY(75))
        love.graphics.setColor(1, 1, 1, 1)
    end

    return viewPortDebug
end

return ViewPortDebug
