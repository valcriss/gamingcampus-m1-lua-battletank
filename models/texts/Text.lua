local Component = require "models.scenes.Component"
---@class Text
Text            = {}

---@param name string
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
Text.new        = function(name, content, alignmentX --[[optional]], alignmentY --[[optional]], x --[[optional]], y --[[optional]], width --[[optional]], height --[[optional]], rotation --[[optional]], scale --[[optional]], color --[[optional]])
    alignmentX = alignmentX or "left"
    alignmentY = alignmentY or "top"
    content    = content or ""
    x          = x or 10
    y          = y or 10
    local text = Component.new(
            name,
            {
                color      = color,
                alignmentX = alignmentX,
                alignmentY = alignmentY,
                content    = content,
                font       = nil,
                textObject = nil
            },
            x,
            y,
            width,
            height,
            rotation,
            scale,
            color
    )

    setmetatable(text, Text)
    Text.__index = Text

    ---@public
    function text.load()
        text.data.font       = love.graphics.getFont()
        text.data.textObject = love.graphics.newText(text.data.font, text.data.content)
    end

    ---@public
    function text.unload()
        text.data.font:release()
        text.data.font = nil
        text.data.textObject:release()
        text.data.textObject = nil
    end

    ---@public
    function text.getWidth()
        return text.data.textObject:getWidth()
    end

    ---@public
    function text.getHeight()
        return text.data.textObject:getHeight()
    end

    ---@public
    function text.draw()
        local originX = 0
        local originY = 0

        if text.data.alignmentX == "center" then originX = 0.5 end
        if text.data.alignmentY == "center" then originY = 0.5 end
        if text.data.alignmentX == "right" then originX = 1 end
        if text.data.alignmentY == "bottom" then originY = 1 end

        love.graphics.draw(text.data.textObject, screenManager:ScaleValueX(text.bounds.x), screenManager:ScaleValueY(text.bounds.y), math.rad(text.rotation), text.scale * screenManager:getScaleX(), text.scale * screenManager:getScaleY(), originX, originY)
    end

    function text:setContent(value)
        text.data.textObject:set(value)
    end

    return text
end

return Text
