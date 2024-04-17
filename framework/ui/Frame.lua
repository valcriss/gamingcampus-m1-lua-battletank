local Component = require "framework.scenes.Component"
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
    local frame = Component.new(name, x, y, width, height)

    setmetatable(frame, Frame)
    Frame.__index = Frame

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local sourceImage
    local topLeft
    local top
    local left
    local right
    local bottom
    local topRight
    local bottomLeft
    local bottomRight
    local center

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function frame.load()
        sourceImage = love.graphics.newImage(assetPath)
        topLeft     = love.graphics.newQuad(0, 0, border, border, sourceImage)
        top         = love.graphics.newQuad(border, 0, border, border, sourceImage)
        left        = love.graphics.newQuad(0, border, border, border, sourceImage)
        right       = love.graphics.newQuad(sourceImage:getWidth() - border, border, border, border, sourceImage)
        bottom      = love.graphics.newQuad(border, sourceImage:getHeight() - border, border, border, sourceImage)
        topRight    = love.graphics.newQuad(sourceImage:getWidth() - border, 0, border, border, sourceImage)
        bottomLeft  = love.graphics.newQuad(0, sourceImage:getHeight() - border, border, border, sourceImage)
        bottomRight = love.graphics.newQuad(sourceImage:getWidth() - border, sourceImage:getHeight() - border, border, border, sourceImage)
        center      = love.graphics.newQuad(border, border, border, border, sourceImage)
    end

    ---@public
    function frame.unload()
        sourceImage:release()
        sourceImage = nil
    end

    ---@public
    function frame.draw()
        -- Top Left
        love.graphics.draw(sourceImage, topLeft, screenManager:ScaleValueX(frame.bounds.x), screenManager:ScaleValueY(frame.bounds.y), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Top Right
        love.graphics.draw(sourceImage, topRight, screenManager:ScaleValueX(frame.bounds.x + frame.bounds.width), screenManager:ScaleValueY(frame.bounds.y), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Bottom Left
        love.graphics.draw(sourceImage, bottomLeft, screenManager:ScaleValueX(frame.bounds.x), screenManager:ScaleValueY(frame.bounds.y + frame.bounds.height), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Bottom Right
        love.graphics.draw(sourceImage, bottomRight, screenManager:ScaleValueX(frame.bounds.x + frame.bounds.width), screenManager:ScaleValueY(frame.bounds.y + frame.bounds.height), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Horizontal Borders
        local horizontalScale = math.ceil(((frame.bounds.x + frame.bounds.width) - (frame.bounds.x + border)) / border)
        love.graphics.draw(sourceImage, top, screenManager:ScaleValueX(frame.bounds.x + border), screenManager:ScaleValueY(frame.bounds.y), 0, horizontalScale * screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        love.graphics.draw(sourceImage, bottom, screenManager:ScaleValueX(frame.bounds.x + border), screenManager:ScaleValueY(frame.bounds.y + frame.bounds.height), 0, horizontalScale * screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Vertical Borders
        local verticalScale = math.ceil(((frame.bounds.y + frame.bounds.height) - (frame.bounds.y + border)) / border)
        love.graphics.draw(sourceImage, left, screenManager:ScaleValueX(frame.bounds.x), screenManager:ScaleValueY(frame.bounds.y + border), 0, screenManager:getScaleX(), verticalScale * screenManager:getScaleY(), 0, 0)
        love.graphics.draw(sourceImage, right, screenManager:ScaleValueX(frame.bounds.x + frame.bounds.width), screenManager:ScaleValueY(frame.bounds.y + border), 0, screenManager:getScaleX(), verticalScale * screenManager:getScaleY(), 0, 0)
        -- Center
        local centerScaleX = math.ceil(((frame.bounds.x + frame.bounds.width) - (frame.bounds.x + border)) / border)
        local centerScaleY = math.ceil(((frame.bounds.y + frame.bounds.height) - (frame.bounds.y + border)) / border)
        love.graphics.draw(sourceImage, center, screenManager:ScaleValueX(frame.bounds.x + border), screenManager:ScaleValueY(frame.bounds.y + border), 0, centerScaleX * screenManager:getScaleX(), centerScaleY * screenManager:getScaleY(), 0, 0)
    end

    return frame
end

return Frame
