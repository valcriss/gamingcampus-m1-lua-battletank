---@class Image
Image = {}

---@param assetPath string
Image.new = function(assetPath)
    local image = {
        assetPath = assetPath,
        image = nil
    }

    setmetatable(image, Image)
    Image.__index = Image

    ---@public
    function image:load()
        image.image = love.graphics.newImage(image.assetPath)
    end

    ---@public
    function image:unload()
        image.image:release()
        image.image = nil
    end

    ---@public
    function image:getWidth()
        return image.image:getWidth()
    end

    ---@public
    function image:getHeight()
        return image.image:getHeight()
    end

    ---@public
    ---@param x number
    ---@param y number
    ---@param rotation number
    function image:draw(x, y, rotation --[[optional]])
        rotation = rotation or 0
        love.graphics.draw(image.image, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), math.rad(rotation), screenManager:getScaleX(), screenManager:getScaleY(), image.image:getWidth() / 2, image.image:getHeight() / 2)
    end

    return image
end

return Image
