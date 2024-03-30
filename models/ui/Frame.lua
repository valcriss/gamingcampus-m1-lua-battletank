local Component = require "models.scenes.Component"
---@class Frame
Frame           = {}

---@param name string
---@param assetPath string
---@param border number
---@param x number
---@param y number
---@param width number
---@param height number
Frame.new       = function(name, assetPath, border, x, y, width, height)
    local frame = Component.new(
            name, {
                assetPath   = assetPath,
                border      = border,
                sourceImage = nil,
                topLeft     = nil,
                top         = nil,
                left        = nil,
                right       = nil,
                bottom      = nil,
                topRight    = nil,
                bottomLeft  = nil,
                bottomRight = nil,
                center      = nil
            },
            x,
            y,
            width,
            height
    )

    setmetatable(frame, Frame)
    Frame.__index = Frame

    ---@public
    function frame.load()
        frame.data.sourceImage = love.graphics.newImage(frame.data.assetPath)
        frame.data.topLeft     = love.graphics.newQuad(0, 0, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.top         = love.graphics.newQuad(frame.data.border, 0, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.left        = love.graphics.newQuad(0, frame.data.border, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.right       = love.graphics.newQuad(frame.data.sourceImage:getWidth() - frame.data.border, frame.data.border, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.bottom      = love.graphics.newQuad(frame.data.border, frame.data.sourceImage:getHeight() - frame.data.border, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.topRight    = love.graphics.newQuad(frame.data.sourceImage:getWidth() - frame.data.border, 0, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.bottomLeft  = love.graphics.newQuad(0, frame.data.sourceImage:getHeight() - frame.data.border, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.bottomRight = love.graphics.newQuad(frame.data.sourceImage:getWidth() - frame.data.border, frame.data.sourceImage:getHeight() - frame.data.border, frame.data.border, frame.data.border, frame.data.sourceImage)
        frame.data.center      = love.graphics.newQuad(frame.data.border, frame.data.border, frame.data.border, frame.data.border, frame.data.sourceImage)
    end

    ---@public
    function frame.unload()
        frame.data.sourceImage:release()
        frame.data.sourceImage = nil
    end

    ---@public
    function frame.draw()
        -- Top Left
        love.graphics.draw(frame.data.sourceImage, frame.data.topLeft, screenManager:ScaleValueX(frame.bounds.x), screenManager:ScaleValueY(frame.bounds.y), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Top Right
        love.graphics.draw(frame.data.sourceImage, frame.data.topRight, screenManager:ScaleValueX(frame.bounds.x + frame.bounds.width), screenManager:ScaleValueY(frame.bounds.y), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Bottom Left
        love.graphics.draw(frame.data.sourceImage, frame.data.bottomLeft, screenManager:ScaleValueX(frame.bounds.x), screenManager:ScaleValueY(frame.bounds.y + frame.bounds.height), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Bottom Right
        love.graphics.draw(frame.data.sourceImage, frame.data.bottomRight, screenManager:ScaleValueX(frame.bounds.x + frame.bounds.width), screenManager:ScaleValueY(frame.bounds.y + frame.bounds.height), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Horizontal Borders
        local horizontalScale = math.ceil(((frame.bounds.x + frame.bounds.width) - (frame.bounds.x + frame.data.border)) / frame.data.border)
        love.graphics.draw(frame.data.sourceImage, frame.data.top, screenManager:ScaleValueX(frame.bounds.x + frame.data.border), screenManager:ScaleValueY(frame.bounds.y), 0, horizontalScale * screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        love.graphics.draw(frame.data.sourceImage, frame.data.bottom, screenManager:ScaleValueX(frame.bounds.x + frame.data.border), screenManager:ScaleValueY(frame.bounds.y + frame.bounds.height), 0, horizontalScale * screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Vertical Borders
        local verticalScale = math.ceil(((frame.bounds.y + frame.bounds.height) - (frame.bounds.y + frame.data.border)) / frame.data.border)
        love.graphics.draw(frame.data.sourceImage, frame.data.left, screenManager:ScaleValueX(frame.bounds.x), screenManager:ScaleValueY(frame.bounds.y + frame.data.border), 0, screenManager:getScaleX(), verticalScale * screenManager:getScaleY(), 0, 0)
        love.graphics.draw(frame.data.sourceImage, frame.data.right, screenManager:ScaleValueX(frame.bounds.x + frame.bounds.width), screenManager:ScaleValueY(frame.bounds.y + frame.data.border), 0, screenManager:getScaleX(), verticalScale * screenManager:getScaleY(), 0, 0)
        -- Center
        local centerScaleX = math.ceil(((frame.bounds.x + frame.bounds.width) - (frame.bounds.x + frame.data.border)) / frame.data.border)
        local centerScaleY = math.ceil(((frame.bounds.y + frame.bounds.height) - (frame.bounds.y + frame.data.border)) / frame.data.border)
        love.graphics.draw(frame.data.sourceImage, frame.data.center, screenManager:ScaleValueX(frame.bounds.x + frame.data.border), screenManager:ScaleValueY(frame.bounds.y + frame.data.border), 0, centerScaleX * screenManager:getScaleX(), centerScaleY * screenManager:getScaleY(), 0, 0)
    end

    return frame
end

return Frame
