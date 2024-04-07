local Component   = require "models.scenes.Component"
local Image       = require "models.images.Image"

---@class TowerStatusUI
TowerStatusUI     = {}

TowerStatusUI.new = function(name)
    local towerStatusUI = Component.new(name)

    setmetatable(towerStatusUI, TowerStatusUI)
    TowerStatusUI.__index = TowerStatusUI

    local mainUi          = Image.new(towerStatusUI.name .. "_mainUi", "assets/gameLevel/ui/towerStatusUI.png", screenManager:calculateCenterPointX(), 32 * .75, nil, 0.75)
    towerStatusUI.addComponent(mainUi)

    return towerStatusUI
end

return TowerStatusUI
