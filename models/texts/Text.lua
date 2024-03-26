---@class Text
Text = {}

Text.new = function()
    local text = {
        font = nil,
        text = nil
    }

    setmetatable(text, Text)
    Text.__index = Text

    function text:load()
        text.font = love.graphics.getFont()
        text.text = love.graphics.newText(text.font, "")
    end

    function text:unload()
        text.text:release()
        text.text = nil
    end

    function text:getWidth()
        return text.text:getWidth()
    end

    function text:getHeight()
        return text.text:getHeight()
    end

    ---@param x number
    ---@param y number
    ---@param content string
    ---@param rotation number
    ---@param alignment string
    function text:draw(x, y, content, rotation --[[optional]], alignment --[[optional]])
        rotation = rotation or 0
        alignment = alignment or "left"
        originX = 0
        originY = 0

        if alignmentX == "center" then
            originX = 0.5
        end
        if alignmentY == "center" then
            originY = 0.5
        end
        if alignmentX == "right" then
            originX = 1
        end
        if alignmentY == "right" then
            originY = 1
        end
        text.text:set(content)
        love.graphics.draw(text.text, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), math.rad(rotation), screenManager:getScaleX(), screenManager:getScaleY(), originX, originY)
    end

    return text
end

return Text
