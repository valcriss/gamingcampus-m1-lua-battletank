local Component = require "models.scenes.Component"

---@class HealthBar
HealthBar       = {}

--- @param gameManager GameManager
HealthBar.new   = function(name, entity, width, height, offsetY)
    width           = width or 32
    height          = height or 6
    offsetY         = offsetY or 16
    local healthBar = Component.new(name)

    setmetatable(healthBar, HealthBar)
    HealthBar.__index       = HealthBar

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local healthBarGroup    = entity.getGroup()
    local healthBarValue    = entity.getHealth()
    local healthBarMaxValue = entity.getMaxHealth()
    local renderInfo
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function healthBar.update(_)
        healthBarValue = entity.getHealth()
        local ratio    = healthBarValue / healthBarMaxValue
        renderInfo     = {
            x               = healthBar.bounds.x - width / 2,
            y               = healthBar.bounds.y + offsetY,
            maxWidth        = width,
            width           = width * ratio,
            height          = height,
            backgroundColor = healthBar.getBackgroundRenderColor(),
            borderColor     = healthBar.getBorderRenderColor(),
            barColor        = healthBar.getBarRenderColor()
        }
    end

    ---@public
    function healthBar.draw()
        if renderInfo == nil then return end
        if healthBarValue >= healthBarMaxValue then return end
        if healthBarValue == 0 then return end
        love.graphics.setColor(renderInfo.backgroundColor.r, renderInfo.backgroundColor.g, renderInfo.backgroundColor.b, renderInfo.backgroundColor.a)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(renderInfo.y), screenManager:ScaleValueX(renderInfo.maxWidth), screenManager:ScaleValueY(renderInfo.height))
        love.graphics.setColor(renderInfo.barColor.r, renderInfo.barColor.g, renderInfo.barColor.b, renderInfo.barColor.a)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(renderInfo.y), screenManager:ScaleValueX(renderInfo.width), screenManager:ScaleValueY(renderInfo.height))
        love.graphics.setColor(renderInfo.borderColor.r, renderInfo.borderColor.g, renderInfo.borderColor.b, renderInfo.borderColor.a)
        love.graphics.rectangle("line", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(renderInfo.y), screenManager:ScaleValueX(renderInfo.maxWidth), screenManager:ScaleValueY(renderInfo.height))
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    function healthBar.getBackgroundRenderColor()
        if healthBarGroup == 0 then
            return { r = 0.9, g = 0.9, b = 0.9, a = 1 }
        elseif healthBarGroup == 1 then
            return { r = 0.9, g = 0.9, b = 0.9, a = 1 }
        elseif healthBarGroup == 2 then
            return { r = 0.9, g = 0.9, b = 0.9, a = 1 }
        end
    end

    function healthBar.getBorderRenderColor()
        if healthBarGroup == 0 then
            return { r = 0.3, g = 0.3, b = 0.3, a = 1 }
        elseif healthBarGroup == 1 then
            return { r = 0.5, g = 0, b = 0, a = 1 }
        elseif healthBarGroup == 2 then
            return { r = 0, g = 0, b = 0.5, a = 1 }
        end
    end

    function healthBar.getBarRenderColor()
        if healthBarGroup == 0 then
            return { r = 0.6, g = 0.6, b = 0.6, a = 1 }
        elseif healthBarGroup == 1 then
            return { r = 1, g = 0.5, b = 0.5, a = 1 }
        elseif healthBarGroup == 2 then
            return { r = 0.5, g = 0.5, b = 1, a = 1 }
        end
    end

    return healthBar
end

return HealthBar
