local Component = require "models.scenes.Component"
---@class Image
Image           = {}

---@param assetPath string
Image.new       = function(name, assetPath, x, y, rotation --[[optional]], scale --[[optional]], color --[[optional]])
    local image = Component.new(
            name,
            {
                assetPath = assetPath,
                image     = nil
            },
            x,
            y,
            nil,
            nil,
            rotation,
            scale,
            color
    )

    setmetatable(image, Image)
    Image.__index = Image

    ---@public
    function image.load()
        image.data.image    = love.graphics.newImage(image.data.assetPath)
        image.bounds.width  = image.data.image:getWidth()
        image.bounds.height = image.data.image:getHeight()
    end

    ---@public
    function image.unload()
        image.data.image:release()
        image.data.image = nil
    end

    ---@public
    function image.getWidth()
        return image.data.image:getWidth()
    end

    ---@public
    function image.getHeight()
        return image.data.image:getHeight()
    end

    ---@public
    function image.draw()
        image.rotation = image.rotation or 0
        love.graphics.draw(image.data.image, screenManager:ScaleValueX(image.bounds.x), screenManager:ScaleValueY(image.bounds.y), math.rad(image.rotation), image.scale * screenManager:getScaleX(), image.scale * screenManager:getScaleY(), image.data.image:getWidth() / 2, image.data.image:getHeight() / 2)
    end

    return image
end

return Image
