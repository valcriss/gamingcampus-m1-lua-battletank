---@class ScreenManager
ScreenManager = {}

ScreenManager.new = function()
    local screenManager = {
        ---@type number
        windowWidth = 0,
        ---@type number
        windowHeight = 0,
        ---@type number
        scaleX = 1,
        ---@type number
        scaleY = 1
    }

    setmetatable(screenManager, ScreenManager)
    ScreenManager.__index = ScreenManager

    -- Classe Properties

    -- Classe functions

    function screenManager:init(width, height)
        screenManager.windowWidth = width
        screenManager.windowHeight = height
        love.window.setMode(width, height, {resizable = true, vsync = 0, minwidth = 800, minheight = 600})
        screenManager.calculateScale()
    end

    function screenManager:resize()
        screenManager.calculateScale()
    end

    function screenManager:calculateScale()
        width = love.graphics.getWidth()
        height = love.graphics.getHeight()
        screenManager.scaleX = width / screenManager.windowWidth
        screenManager.scaleY = height / screenManager.windowHeight
    end

    ---@public
    function screenManager:calculateCenterPointX()
        return screenManager.windowWidth / 2
    end

    ---@public
    function screenManager:calculateCenterPointY()
        return screenManager.windowHeight / 2
    end

    function screenManager:getWindowWidth()
        return screenManager.windowWidth
    end

    function screenManager:getWindowHeight()
        return screenManager.windowHeight
    end

    function screenManager:getScaleX()
        return screenManager.scaleX
    end

    function screenManager:getScaleY()
        return screenManager.scaleY
    end

    function screenManager:ScaleValueX(x)
        return x * screenManager.scaleX
    end

    function screenManager:ScaleValueY(y)
        return y * screenManager.scaleY
    end

    return screenManager
end

return ScreenManager
