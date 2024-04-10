local Component       = require "models.scenes.Component"

---@class MainTowerHeathBar
MainTowerHeathBar     = {}

MainTowerHeathBar.new = function(name, mainTower)
    local mainTowerHeathBar = Component.new(name)

    setmetatable(mainTowerHeathBar, MainTowerHeathBar)
    MainTowerHeathBar.__index = MainTowerHeathBar

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    local healthBarGroup      = mainTower.getGroup()
    local healthBarValue      = mainTower.getHealth()
    local healthBarMaxValue   = mainTower.getMaxHealth()
    local width               = 285
    local height              = 15
    local renderInfo

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function mainTowerHeathBar.update(_)
        healthBarValue = mainTower.getHealth()
        local ratio    = healthBarValue / healthBarMaxValue
        renderInfo     = {
            x               = mainTowerHeathBar.bounds.x,
            y               = mainTowerHeathBar.bounds.y,
            barX            = mainTowerHeathBar.bounds.x,
            maxWidth        = width,
            width           = width * ratio,
            height          = height,
            backgroundColor = mainTowerHeathBar.getBackgroundRenderColor(),
            borderColor     = mainTowerHeathBar.getBorderRenderColor(),
            barColor        = mainTowerHeathBar.getBarRenderColor()
        }
    end

    ---@public
    function mainTowerHeathBar.draw()
        if renderInfo == nil then return end
        love.graphics.setColor(renderInfo.backgroundColor.r, renderInfo.backgroundColor.g, renderInfo.backgroundColor.b, renderInfo.backgroundColor.a)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(renderInfo.y), screenManager:ScaleValueX(renderInfo.maxWidth), screenManager:ScaleValueY(renderInfo.height), height / 4, height / 4)
        love.graphics.setColor(renderInfo.barColor.r, renderInfo.barColor.g, renderInfo.barColor.b, renderInfo.barColor.a)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(renderInfo.barX), screenManager:ScaleValueY(renderInfo.y), screenManager:ScaleValueX(renderInfo.width), screenManager:ScaleValueY(renderInfo.height))
        love.graphics.setColor(renderInfo.borderColor.r, renderInfo.borderColor.g, renderInfo.borderColor.b, renderInfo.borderColor.a)
        love.graphics.rectangle("line", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(renderInfo.y), screenManager:ScaleValueX(renderInfo.maxWidth), screenManager:ScaleValueY(renderInfo.height), height / 4, height / 4)
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    function mainTowerHeathBar.getBackgroundRenderColor()
        if healthBarGroup == 0 then
            return { r = 0.9, g = 0.9, b = 0.9, a = 1 }
        elseif healthBarGroup == 1 then
            return { r = 0.9, g = 0.9, b = 0.9, a = 1 }
        elseif healthBarGroup == 2 then
            return { r = 0.9, g = 0.9, b = 0.9, a = 1 }
        end
    end

    function mainTowerHeathBar.getBorderRenderColor()
        if healthBarGroup == 0 then
            return { r = 0.3, g = 0.3, b = 0.3, a = 1 }
        elseif healthBarGroup == 1 then
            return { r = 0.5, g = 0, b = 0, a = 1 }
        elseif healthBarGroup == 2 then
            return { r = 0, g = 0, b = 0.5, a = 1 }
        end
    end

    function mainTowerHeathBar.getBarRenderColor()
        if healthBarGroup == 0 then
            return { r = 0.6, g = 0.6, b = 0.6, a = 1 }
        elseif healthBarGroup == 1 then
            return { r = 1, g = 0.5, b = 0.5, a = 1 }
        elseif healthBarGroup == 2 then
            return { r = 0.5, g = 0.5, b = 1, a = 1 }
        end
    end

    return mainTowerHeathBar
end

return MainTowerHeathBar
