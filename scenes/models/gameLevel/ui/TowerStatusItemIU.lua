local Component           = require "models.scenes.Component"
local Image               = require "models.images.Image"
local TowerStatusHeathBar = require "scenes.models.gameLevel.ui.TowerStatusHeathBar"

---@class TowerStatusItemUI
TowerStatusItemUI         = {}

TowerStatusItemUI.new     = function(name, flagItem, x, y)
    local towerStatusItemUI = Component.new(name, {}, x, y, 27, 37, 0, 1)

    setmetatable(towerStatusItemUI, TowerStatusItemUI)
    TowerStatusItemUI.__index = TowerStatusItemUI

    local owner               = 0
    local flagMarker          = Image.new(towerStatusItemUI.name .. "_towerOwner0", "assets/gameLevel/flag-marker.png", x, y, nil, 1)
    local towerStatusHeathBar = TowerStatusHeathBar.new(towerStatusItemUI.name .. "_towerStatusHeathBar", flagItem, x, y)
    local towerNumber         = Image.new(towerStatusItemUI.name .. "_towerNumber", "assets/gameLevel/flag-" .. tostring(flagItem.getIndex()) .. ".png", x, y, nil, 0.25)

    towerStatusItemUI.addComponent(towerStatusHeathBar)
    towerStatusItemUI.addComponent(flagMarker)
    towerStatusItemUI.addComponent(towerNumber)

    function towerStatusItemUI.load()
        towerStatusItemUI.setOwner(0)
    end

    function towerStatusItemUI.updateUnitAttacker(fromGroup)
        towerStatusHeathBar.updateUnitAttacker(fromGroup)
    end

    function towerStatusItemUI.setOwner(newOwner)
        owner = newOwner
    end

    return towerStatusItemUI
end

return TowerStatusItemUI
