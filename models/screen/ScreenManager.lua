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

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Initialise le screen manager avec les dimensions de développement
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

    ---@public
    --- Recharge la configuration de l'écran
    function screenManager:reload()
        love.window.setMode(screenManager.windowWidth, screenManager.windowHeight, { fullscreen = configuration:isFullScreen(), fullscreentype = "desktop", resizable = true, vsync = configuration:getVsyncAsInteger(), stencil = true, msaa = 0, minwidth = 910, minheight = 512 })
        if not configuration:isFullScreen() and configuration:isMaximized() then
            love.window.maximize()
        end
        screenManager.calculateScale()
    end

    ---@public
    --- Fonction appelée lors du redimensionnement de la fenêtre
    function screenManager:resize()
        screenManager.calculateScale()
    end

    ---@private
    --- Calcul du ratio de resolution de l'écran
    function screenManager:calculateScale()
        width                = love.graphics.getWidth()
        height               = love.graphics.getHeight()
        screenManager.scaleX = width / screenManager.windowWidth
        screenManager.scaleY = height / screenManager.windowHeight
    end

    ---@public
    --- Calcul du centre de l'écran horizontalement
    function screenManager:calculateCenterPointX()
        return screenManager.windowWidth / 2
    end

    ---@public
    --- Calcul du centre de l'écran verticalement
    function screenManager:calculateCenterPointY()
        return screenManager.windowHeight / 2
    end

    ---@public
    --- Retourne la largeur de l'écran
    function screenManager:getWindowWidth()
        return screenManager.windowWidth
    end

    ---@public
    --- Retourne la hauteur de l'écran
    function screenManager:getWindowHeight()
        return screenManager.windowHeight
    end

    ---@public
    --- Retourne le ratio de resolution de l'écran horizontal
    function screenManager:getScaleX()
        return screenManager.scaleX
    end

    ---@public
    --- Retourne le ratio de resolution de l'écran vertical
    function screenManager:getScaleY()
        return screenManager.scaleY
    end

    ---@public
    --- Retourne une valeur multipliee par le ratio de resolution horizontal
    function screenManager:ScaleValueX(x)
        return x * screenManager.scaleX
    end

    ---@public
    --- Retourne une valeur multipliee par le ratio de resolution vertical
    function screenManager:ScaleValueY(y)
        return y * screenManager.scaleY
    end

    ---@public
    --- Retourne une valeur multipliee par le ratio de resolution pour l'interface utilisateur horizontal
    function screenManager:ScaleUIValueX(x)
        return x * (screenManager.windowWidth / love.graphics.getWidth())
    end

    ---@public
    --- Retourne une valeur multipliee par le ratio de resolution pour l'interface utilisateur vertical
    function screenManager:ScaleUIValueY(y)
        return y * (screenManager.windowHeight / love.graphics.getHeight())
    end

    ---@public
    --- Rafraichi l'écran avec une couleur RGBA
    function screenManager:clear(r, g, b)
        love.graphics.clear(r, g, b, 1)
    end

    return screenManager
end

return ScreenManager
