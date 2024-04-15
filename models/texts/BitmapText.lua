local Component = require "models.scenes.Component"

---@class BitmapText
BitmapText      = {}

---@param name string
---@param bmfFontData string
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
BitmapText.new  = function(name, bmfFontData, content, alignmentX --[[optional]], alignmentY --[[optional]], x --[[optional]], y --[[optional]], width --[[optional]], height --[[optional]], rotation --[[optional]], scale --[[optional]], color --[[optional]])
    content          = content or ""
    alignmentX       = alignmentX or "left"
    alignmentY       = alignmentY or "top"
    local bitmapText = Component.new(name, x, y, width, height, rotation, scale, color)

    setmetatable(bitmapText, BitmapText)
    BitmapText.__index = BitmapText

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type table
    local font
    ---@type table
    local text

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    --- Fonction appelée automatiquement qui charge la police depuis la ressource
    function bitmapText.load()
        font = love.graphics.newFont(bmfFontData)
        text = love.graphics.newText(font, content)
    end

    ---@public
    --- Fonction appelée automatiquement qui décharge la police
    function bitmapText.unload()
        text:release()
        text = nil
    end

    ---@public
    --- Retourne la largeur du texte
    function bitmapText.getWidth()
        return text:getWidth()
    end

    ---@public
    --- Retourne la hauteur du texte
    function bitmapText.getHeight()
        return text:getHeight()
    end

    ---@public
    --- Fonction appelée automatiquement qui dessine le texte
    function bitmapText.draw()
        local originX = 0
        local originY = 0

        if alignmentX == "center" then
            originX = bitmapText:getWidth() / 2
        elseif alignmentX == "right" then
            originX = bitmapText:getWidth()
        end
        if alignmentY == "center" then
            originY = bitmapText:getHeight() / 2
        elseif alignmentY == "bottom" then
            originY = bitmapText:getHeight()
        end

        love.graphics.draw(text, screenManager:ScaleValueX(bitmapText.bounds.x), screenManager:ScaleValueY(bitmapText.bounds.y), math.rad(bitmapText.rotation), bitmapText.scale * screenManager:getScaleX(), bitmapText.scale * screenManager:getScaleY(), originX, originY)
    end

    ---@public
    --- Fonction qui permet de définir le texte affiché
    ---@param newContent string
    function bitmapText.setContent(newContent)
        text:set(newContent)
    end

    return bitmapText
end

return BitmapText
