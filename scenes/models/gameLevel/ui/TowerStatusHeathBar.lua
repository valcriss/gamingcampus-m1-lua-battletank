local Component         = require "models.scenes.Component"

---@class TowerStatusHeathBar
TowerStatusHeathBar     = {}

TowerStatusHeathBar.new = function(name, flagItem, x, y)
    local towerStatusHeathBar = Component.new(name, {}, x, y)

    setmetatable(towerStatusHeathBar, TowerStatusHeathBar)
    TowerStatusHeathBar.__index = TowerStatusHeathBar

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local attackerGroup
    local lastAttack            = math.huge
    local healthBarGroup        = flagItem.getGroup()
    local healthBarValue        = flagItem.getHealth()
    local healthBarMaxValue     = flagItem.getMaxHealth()
    local width                 = 24
    local height                = 32
    local offsetX               = 23 / 2
    local offsetY               = 32 / 2
    local renderInfo

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function towerStatusHeathBar.update(dt)
        healthBarValue       = flagItem.getHealth()
        healthBarGroup       = flagItem.getGroup()
        local ratio          = healthBarValue / healthBarMaxValue
        local ownerBarHeight = height * ratio
        renderInfo           = attackerGroup == nil and {
            hasAttacker                = false,
            x                          = towerStatusHeathBar.bounds.x - offsetX,
            attackerBarY               = nil,
            attackerBarHeight          = nil,
            attackerBarBackgroundColor = nil,
            ownerBarY                  = towerStatusHeathBar.bounds.y - offsetY + (height - ownerBarHeight),
            ownerBarHeight             = ownerBarHeight,
            ownerBarBackgroundColor    = towerStatusHeathBar.getBackgroundRenderColor(healthBarGroup)
        } or {
            hasAttacker                = true,
            x                          = towerStatusHeathBar.bounds.x - offsetX,
            attackerBarY               = towerStatusHeathBar.bounds.y - offsetY,
            attackerBarHeight          = (height - ownerBarHeight),
            attackerBarBackgroundColor = towerStatusHeathBar.getBackgroundRenderColor(attackerGroup),
            ownerBarY                  = towerStatusHeathBar.bounds.y - offsetY + (height - ownerBarHeight),
            ownerBarHeight             = ownerBarHeight,
            ownerBarBackgroundColor    = towerStatusHeathBar.getBackgroundRenderColor(healthBarGroup)
        }
        if attackerGroup ~= nil then
            lastAttack = lastAttack + dt
            if (lastAttack > 5) then
                attackerGroup = nil
            end
        end
    end

    ---@public
    function towerStatusHeathBar.draw()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(towerStatusHeathBar.bounds.y - offsetY), screenManager:ScaleValueX(width), screenManager:ScaleValueY(height))

        if renderInfo.hasAttacker then
            love.graphics.setColor(renderInfo.attackerBarBackgroundColor.r, renderInfo.attackerBarBackgroundColor.g, renderInfo.attackerBarBackgroundColor.b, renderInfo.attackerBarBackgroundColor.a)
            love.graphics.rectangle("fill", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(renderInfo.attackerBarY), screenManager:ScaleValueX(width), screenManager:ScaleValueY(renderInfo.attackerBarHeight))
        end
        love.graphics.setColor(renderInfo.ownerBarBackgroundColor.r, renderInfo.ownerBarBackgroundColor.g, renderInfo.ownerBarBackgroundColor.b, renderInfo.ownerBarBackgroundColor.a)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(renderInfo.x), screenManager:ScaleValueY(renderInfo.ownerBarY), screenManager:ScaleValueX(width), screenManager:ScaleValueY(renderInfo.ownerBarHeight))
        love.graphics.setColor(1, 1, 1, 1)
    end

    function towerStatusHeathBar.updateUnitAttacker(fromGroup)
        attackerGroup = fromGroup
        lastAttack    = 0
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    function towerStatusHeathBar.getBackgroundRenderColor(group)
        if group == 0 then
            return { r = 0.8, g = 0.8, b = 0.8, a = 1 }
        elseif group == 1 then
            return { r = 1, g = 0.5, b = 0.5, a = 1 }
        elseif group == 2 then
            return { r = 0.5, g = 0.5, b = 1, a = 1 }
        end
    end

    return towerStatusHeathBar
end

return TowerStatusHeathBar
