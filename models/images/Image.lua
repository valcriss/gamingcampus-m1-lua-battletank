local Component = require "models.scenes.Component"

---@class Image
Image           = {}

---@param name string
---@param assetPath string
---@param x number
---@param y number
---@param rotation number
---@param scale number
---@param color table
Image.new       = function(name, assetPath, x, y, rotation --[[optional]], scale --[[optional]], color --[[optional]])
    x           = x or 0
    y           = y or 0
    rotation    = rotation or 0
    scale       = scale or 1
    color       = color or { r = 1, g = 1, b = 1, a = 1 }

    local image = Component.new(name, x, y, 0, 0, rotation, scale, color)

    setmetatable(image, Image)
    Image.__index = Image
    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type table
    local bitmapImage

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    --- Fonction appelée automatiquement qui charge l'image depuis la ressource
    function image.load()
        bitmapImage         = love.graphics.newImage(assetPath)
        image.bounds.width  = bitmapImage:getWidth()
        image.bounds.height = bitmapImage:getHeight()
    end

    ---@public
    --- Fonction appelée automatiquement qui decharge l'image
    function image.unload()
        bitmapImage:release()
        bitmapImage = nil
    end

    ---@public
    --- Fonction appelée automatiquement qui dessine l'image
    function image.draw()
        love.graphics.draw(bitmapImage, screenManager:ScaleValueX(image.bounds.x), screenManager:ScaleValueY(image.bounds.y), math.rad(image.rotation), image.scale * screenManager:getScaleX(), image.scale * screenManager:getScaleY(), bitmapImage:getWidth() / 2, bitmapImage:getHeight() / 2)
    end

    return image
end

return Image
