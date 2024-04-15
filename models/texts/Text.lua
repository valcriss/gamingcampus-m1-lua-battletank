local Component = require "models.scenes.Component"
---@class Text
Text            = {}

---@param name string
---@param content string
---@param alignmentX string
---@param alignmentY string
---@param x number
---@param y number
---@param width number
---@param height number
---@param rotation number
---@param scale number
---@param color table
Text.new        = function(name, content, alignmentX --[[optional]], alignmentY --[[optional]], x --[[optional]], y --[[optional]], width --[[optional]], height --[[optional]], rotation --[[optional]], scale --[[optional]], color --[[optional]])
    content    = content or ""
    alignmentX = alignmentX or "left"
    alignmentY = alignmentY or "top"
    content    = content or ""
    x          = x or 10
    y          = y or 10

    local text = Component.new(name, x, y, width, height, rotation, scale, color)

    setmetatable(text, Text)
    Text.__index = Text

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type table
    local font
    ---@type table
    local textObject

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    --- Fonction appelée automatiquement qui charge la police par defaut love
    function text.load()
        font       = love.graphics.getFont()
        textObject = love.graphics.newText(font, content)
    end

    ---@public
    --- Fonction appelée automatiquement qui décharge la police
    function text.unload()
        font:release()
        font = nil
        textObject:release()
        textObject = nil
    end

    ---@public
    --- Retourne la largeur du texte
    function text.getWidth()
        return textObject:getWidth()
    end

    ---@public
    --- Retourne la hauteur du texte
    function text.getHeight()
        return textObject:getHeight()
    end

    ---@public
    --- Fonction appelée automatiquement qui dessine le texte
    function text.draw()
        local originX = 0
        local originY = 0

        if alignmentX == "center" then originX = 0.5 end
        if alignmentY == "center" then originY = 0.5 end
        if alignmentX == "right" then originX = 1 end
        if alignmentY == "bottom" then originY = 1 end

        love.graphics.draw(textObject, screenManager:ScaleValueX(text.bounds.x), screenManager:ScaleValueY(text.bounds.y), math.rad(text.rotation), text.scale * screenManager:getScaleX(), text.scale * screenManager:getScaleY(), originX, originY)
    end

    ---@public
    --- Fonction qui permet de définir le texte affiché
    ---@param value string
    function text:setContent(value)
        textObject:set(value)
    end

    return text
end

return Text
