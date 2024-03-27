---@class BitmapText
BitmapText = {}

BitmapText.new = function(bmfFontData)
    local bitmapText = {
        font = nil,
        fontData = bmfFontData,
        text = nil
    }

    setmetatable(bitmapText, BitmapText)
    BitmapText.__index = BitmapText

    ---@public
    function bitmapText:load()
        bitmapText.font = love.graphics.newFont(bmfFontData)
        bitmapText.text = love.graphics.newText(bitmapText.font, "")
    end

    ---@public
    function bitmapText:unload()
        bitmapText.text:release()
        bitmapText.text = nil
    end

    ---@public
    function bitmapText:getWidth()
        return bitmapText.text:getWidth()
    end

    ---@public
    function bitmapText:getHeight()
        return bitmapText.text:getHeight()
    end

    ---@public
    ---@param x number
    ---@param y number
    ---@param content string
    ---@param rotation number
    ---@param alignmentX string
    ---@param alignmentY string
    function bitmapText:draw(x, y, content, rotation --[[optional]], alignmentX --[[optional]], alignmentY --[[optional]])
        rotation = rotation or 0
        alignment = alignment or "left"
        originX = 0
        originY = 0
        bitmapText.text:set(content)

        if alignmentX == "center" then
            originX = bitmapText.getWidth() / 2
        end
        if alignmentY == "center" then
            originY = bitmapText.getHeight() / 2
        end
        if alignmentX == "right" then
            originX = bitmapText.getWidth()
        end
        if alignmentY == "right" then
            originY = bitmapText.getHeight()
        end
        love.graphics.draw(bitmapText.text, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), math.rad(rotation), screenManager:getScaleX(), screenManager:getScaleY(), originX, originY)
    end

    return bitmapText
end

return BitmapText
