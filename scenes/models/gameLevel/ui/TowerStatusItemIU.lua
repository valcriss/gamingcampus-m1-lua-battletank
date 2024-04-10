local Component       = require "models.scenes.Component"
local Image           = require "models.images.Image"

---@class TowerStatusItemUI
TowerStatusItemUI     = {}

TowerStatusItemUI.new = function(name, x, y)
    local towerStatusItemUI = Component.new(name, {}, x, y, 19, 26, 0, 1)

    setmetatable(towerStatusItemUI, TowerStatusItemUI)
    TowerStatusItemUI.__index = TowerStatusItemUI

    local towerOwner0         = Image.new(towerStatusItemUI.name .. "_towerOwner0", "assets/gameLevel/ui/tower-owner-0.png", x, y, nil, 1)
    local towerOwner1         = Image.new(towerStatusItemUI.name .. "_towerOwner1", "assets/gameLevel/ui/tower-owner-1.png", x, y, nil, 1)
    local towerOwner2         = Image.new(towerStatusItemUI.name .. "_towerOwner2", "assets/gameLevel/ui/tower-owner-2.png", x, y, nil, 1)

    towerStatusItemUI.addComponent(towerOwner0)
    towerStatusItemUI.addComponent(towerOwner1)
    towerStatusItemUI.addComponent(towerOwner2)

    function towerStatusItemUI.load()
        towerStatusItemUI.setOwner(0)
    end

    function towerStatusItemUI.setOwner(newOwner)
        if newOwner == 0 then
            towerOwner0.show()
            towerOwner1.hide()
            towerOwner2.hide()
        elseif newOwner == 1 then
            towerOwner0.hide()
            towerOwner1.show()
            towerOwner2.hide()
        elseif newOwner == 2 then
            towerOwner0.hide()
            towerOwner1.hide()
            towerOwner2.show()
        end
    end

    return towerStatusItemUI
end

return TowerStatusItemUI
