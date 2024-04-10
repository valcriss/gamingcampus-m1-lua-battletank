local Component         = require "models.scenes.Component"
local Image             = require "models.images.Image"
local TowerStatusItemUI = require "scenes.models.gameLevel.ui.TowerStatusItemIU"

---@class TowerStatusUI
TowerStatusUI           = {}

TowerStatusUI.new       = function(name, gameManager)
    local towerStatusUI = Component.new(name)

    setmetatable(towerStatusUI, TowerStatusUI)
    TowerStatusUI.__index = TowerStatusUI

    local mainUi          = Image.new(towerStatusUI.name .. "_mainUi", "assets/gameLevel/ui/towerStatusUI.png", screenManager:calculateCenterPointX(), 25, nil, 1)
    towerStatusUI.addComponent(mainUi)

    local flagItems = {}

    function towerStatusUI.load()
        flagItems       = {}
        local flags     = gameManager.getFlags()
        local flagCount = #flags
        local padding   = 20
        local w         = 19 * flagCount + (padding * (flagCount - 1))
        local x         = (screenManager:calculateCenterPointX() - w / 2) + (19 / 2)
        for _, item in ipairs(flags) do
            local flagItem = TowerStatusItemUI.new(item.name, x, 22)
            table.insert(flagItems, flagItem)
            towerStatusUI.addComponent(flagItem)
            x = x + (padding + 19)
        end
    end

    function towerStatusUI.setFlagCaptured(unit, fromGroup)
        for _, flagItem in ipairs(flagItems) do
            if (flagItem.name == unit.name) then
                flagItem.setOwner(fromGroup)
                break
            end
        end
    end

    return towerStatusUI
end

return TowerStatusUI
