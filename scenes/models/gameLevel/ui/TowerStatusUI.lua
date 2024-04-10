local Component         = require "models.scenes.Component"
local Image             = require "models.images.Image"
local TowerStatusItemUI = require "scenes.models.gameLevel.ui.TowerStatusItemIU"

---@class TowerStatusUI
TowerStatusUI           = {}

TowerStatusUI.new       = function(name, gameManager)
    local towerStatusUI = Component.new(name)

    setmetatable(towerStatusUI, TowerStatusUI)
    TowerStatusUI.__index       = TowerStatusUI

    local towerStatusBackground = Image.new(towerStatusUI.name .. "_towerStatusBackground", "assets/gameLevel/ui/statusUI.png", screenManager:calculateCenterPointX(), 25, nil, 1)

    towerStatusUI.addComponent(towerStatusBackground)

    local flagItems = {}

    function towerStatusUI.load()
        flagItems       = {}
        local flags     = gameManager.getFlags()
        local flagCount = #flags
        local padding   = 20
        local w         = 19 * flagCount + (padding * (flagCount - 1))
        local x         = (screenManager:calculateCenterPointX() - w / 2) + (19 / 2)
        for _, item in ipairs(flags) do
            local flagItem = TowerStatusItemUI.new(item.name, item, x, 22)
            table.insert(flagItems, flagItem)
            towerStatusUI.addComponent(flagItem)
            x = x + (padding + 19)
        end
    end

    function towerStatusUI.setFlagCaptured(unit, fromGroup)
        local flagItem = towerStatusUI.getUnitByName(unit.name)
        if (flagItem == nil) then return end
        flagItem.setOwner(fromGroup)
    end

    function towerStatusUI.setUnitUnderAttack(unit, _, fromGroup)
        local flagItem = towerStatusUI.getUnitByName(unit.name)
        if (flagItem == nil) then return end
        flagItem.updateUnitAttacker(fromGroup)
    end

    function towerStatusUI.getUnitByName(unitName)
        for _, flagItem in ipairs(flagItems) do
            if (flagItem.name == unitName) then
                return flagItem
            end
        end
        return nil
    end

    return towerStatusUI
end

return TowerStatusUI
