local Component = require "models.scenes.Component"

---@class BitmapText
BitmapText      = {}

BitmapText.new  = function(name, bmfFontData, content, alignmentX --[[optional]], alignmentY --[[optional]], x --[[optional]], y --[[optional]], width --[[optional]], height --[[optional]], rotation --[[optional]], scale --[[optional]], color --[[optional]])
    alignmentX       = alignmentX or "left"
    alignmentY       = alignmentY or "top"
    local bitmapText = Component.new(
            name,
            {
                fontData   = bmfFontData,
                alignmentX = alignmentX,
                alignmentY = alignmentY,
                content    = content,
                font       = nil,
                text       = nil,
            },
            x,
            y,
            width,
            height,
            rotation,
            scale,
            color
    )

    setmetatable(bitmapText, BitmapText)
    BitmapText.__index = BitmapText

    ---@public
    function bitmapText.load()
        bitmapText.data.font = love.graphics.newFont(bitmapText.data.fontData)
        bitmapText.data.text = love.graphics.newText(bitmapText.data.font, bitmapText.data.content)
    end

    ---@public
    function bitmapText.unload()
        bitmapText.data.text:release()
        bitmapText.data.text = nil
    end

    ---@public
    function bitmapText.getWidth()
        return bitmapText.data.text:getWidth()
    end

    ---@public
    function bitmapText.getHeight()
        return bitmapText.data.text:getHeight()
    end

    ---@public
    function bitmapText.draw()
        local originX = 0
        local originY = 0

        if bitmapText.data.alignmentX == "center" then
            originX = bitmapText:getWidth() / 2
        elseif bitmapText.data.alignmentX == "right" then
            originX = bitmapText:getWidth()
        end
        if bitmapText.data.alignmentY == "center" then
            originY = bitmapText:getHeight() / 2
        elseif bitmapText.data.alignmentY == "bottom" then
            originY = bitmapText:getHeight()
        end

        love.graphics.draw(bitmapText.data.text, screenManager:ScaleValueX(bitmapText.bounds.x), screenManager:ScaleValueY(bitmapText.bounds.y), math.rad(bitmapText.rotation), bitmapText.scale * screenManager:getScaleX(), bitmapText.scale * screenManager:getScaleY(), originX, originY)
    end

    function bitmapText.setContent(newContent)
        bitmapText.data.content = newContent
        bitmapText.data.text:set(bitmapText.data.content)
    end

    return bitmapText
end

return BitmapText
