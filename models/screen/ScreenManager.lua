---@class ScreenManager
ScreenManager     = {}

ScreenManager.new = function()
    local screenManager = {
        ---@type number
        windowWidth  = 0,
        ---@type number
        windowHeight = 0,
        ---@type number
        scaleX       = 1,
        ---@type number
        scaleY       = 1
    }

    setmetatable(screenManager, ScreenManager)
    ScreenManager.__index = ScreenManager

    ---@public
    ---@param width number
    ---@param height number
    function screenManager:init(width, height)
        screenManager.windowWidth  = width
        screenManager.windowHeight = height

        love.window.setMode(width, height, { fullscreen = configuration:isFullScreen(), fullscreentype = "desktop", resizable = true, vsync = configuration:getVsyncAsInteger(), stencil = true, msaa = 0, minwidth = 910, minheight = 512 })
        if not configuration:isFullScreen() and configuration:isMaximized() then
            love.window.maximize()
        end
        screenManager.calculateScale()
    end

    function screenManager:reload()
        love.window.setMode(screenManager.windowWidth, screenManager.windowHeight, { fullscreen = configuration:isFullScreen(), fullscreentype = "desktop", resizable = true, vsync = configuration:getVsyncAsInteger(), stencil = true, msaa = 0, minwidth = 910, minheight = 512 })
        if not configuration:isFullScreen() and configuration:isMaximized() then
            love.window.maximize()
        end
        screenManager.calculateScale()
    end

    ---@public
    function screenManager:resize()
        screenManager.calculateScale()
    end

    ---@private
    function screenManager:calculateScale()
        width                = love.graphics.getWidth()
        height               = love.graphics.getHeight()
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

    ---@public
    function screenManager:getWindowWidth()
        return screenManager.windowWidth
    end

    ---@public
    function screenManager:getWindowHeight()
        return screenManager.windowHeight
    end

    ---@public
    function screenManager:getScaleX()
        return screenManager.scaleX
    end

    ---@public
    function screenManager:getScaleY()
        return screenManager.scaleY
    end

    ---@public
    function screenManager:ScaleValueX(x)
        return x * screenManager.scaleX
    end

    ---@public
    function screenManager:ScaleValueY(y)
        return y * screenManager.scaleY
    end

    ---@public
    function screenManager:ScaleUIValueX(x)
        return x * (screenManager.windowWidth / love.graphics.getWidth())
    end

    ---@public
    function screenManager:ScaleUIValueY(y)
        return y * (screenManager.windowHeight / love.graphics.getHeight())
    end

    function screenManager:clear(r, g, b)
        love.graphics.clear(r / 255, g / 255, b / 255, 1)
    end

    return screenManager
end

return ScreenManager
