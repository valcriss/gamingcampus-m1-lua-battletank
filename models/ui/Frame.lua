---@class Frame
Frame = {}

Frame.new = function(assetPath, border, x, y, width, height)
    local frame = {
        assetPath = assetPath,
        border = border,
        x = x,
        y = y,
        width = width,
        height = height,
        sourceImage = nil,
        topLeft = nil,
        top = nil,
        left = nil,
        right = nil,
        bottom = nil,
        topRight = nil,
        bottomLeft = nil,
        bottomRight = nil,
        center = nil
    }

    setmetatable(frame, Frame)
    Frame.__index = Frame

    ---@public
    function frame:load()
        frame.sourceImage = love.graphics.newImage(frame.assetPath)
        frame.topLeft = love.graphics.newQuad(0, 0, frame.border, frame.border, frame.sourceImage)
        frame.top = love.graphics.newQuad(frame.border, 0, frame.border, frame.border, frame.sourceImage)
        frame.left = love.graphics.newQuad(0, frame.border, frame.border, frame.border, frame.sourceImage)
        frame.right = love.graphics.newQuad(frame.sourceImage:getWidth() - frame.border, frame.border, frame.border, frame.border, frame.sourceImage)
        frame.bottom = love.graphics.newQuad(frame.border, frame.sourceImage:getHeight() - frame.border, frame.border, frame.border, frame.sourceImage)
        frame.topRight = love.graphics.newQuad(frame.sourceImage:getWidth() - frame.border, 0, frame.border, frame.border, frame.sourceImage)
        frame.bottomLeft = love.graphics.newQuad(0, frame.sourceImage:getHeight() - frame.border, frame.border, frame.border, frame.sourceImage)
        frame.bottomRight = love.graphics.newQuad(frame.sourceImage:getWidth() - frame.border, frame.sourceImage:getHeight() - frame.border, frame.border, frame.border, frame.sourceImage)
        frame.center = love.graphics.newQuad(frame.border, frame.border, frame.border, frame.border, frame.sourceImage)
    end

    ---@public
    function frame:unload()
        frame.sourceImage:release()
        frame.sourceImage = nil
    end

    ---@public
    function frame:draw()
        -- Top Left
        love.graphics.draw(frame.sourceImage, frame.topLeft, screenManager:ScaleValueX(frame.x), screenManager:ScaleValueY(frame.y), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Top Right
        love.graphics.draw(frame.sourceImage, frame.topRight, screenManager:ScaleValueX(frame.x + frame.width), screenManager:ScaleValueY(frame.y), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Bottom Left
        love.graphics.draw(frame.sourceImage, frame.bottomLeft, screenManager:ScaleValueX(frame.x), screenManager:ScaleValueY(frame.y + frame.height), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Bottom Right
        love.graphics.draw(frame.sourceImage, frame.bottomRight, screenManager:ScaleValueX(frame.x + frame.width), screenManager:ScaleValueY(frame.y + frame.height), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        -- Horizontal Borders
        for xBorder = frame.x + frame.border, frame.x + frame.width - frame.border do
            love.graphics.draw(frame.sourceImage, frame.top, screenManager:ScaleValueX(xBorder), screenManager:ScaleValueY(frame.y), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
            love.graphics.draw(frame.sourceImage, frame.bottom, screenManager:ScaleValueX(xBorder), screenManager:ScaleValueY(frame.y + frame.height), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        end
        -- Vertical Borders
        for yBorder = frame.y + frame.border, y + frame.height - frame.border do
            love.graphics.draw(frame.sourceImage, frame.left, screenManager:ScaleValueX(frame.x), screenManager:ScaleValueY(yBorder), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
            love.graphics.draw(frame.sourceImage, frame.right, screenManager:ScaleValueX(frame.x + frame.width), screenManager:ScaleValueY(yBorder), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        end
        -- Center
        for xCenter = frame.x + frame.border, frame.x + frame.width - frame.border do
            for yCenter = frame.y + frame.border, frame.y + frame.height - frame.border do
                love.graphics.draw(frame.sourceImage, frame.center, screenManager:ScaleValueX(xCenter), screenManager:ScaleValueY(yCenter), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
            end
        end
    end

    function frame:setPosition(x, y)
        frame.x = x
        frame.y = y
    end

    return frame
end

return Frame
