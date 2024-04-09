local Component = require "models.scenes.Component"
local TowerStatusUI = require "scenes.models.gameLevel.ui.TowerStatusUI"

---@class UIManager
UIManager           = {}

UIManager.new       = function()

    local uiManager = Component.new("UIManager")

    setmetatable(uiManager, UIManager)
    UIManager.__index   = UIManager

    local towerStatusUI = TowerStatusUI.new("TowerStatusUI")
    uiManager.addComponent(towerStatusUI)

    return uiManager
end

return UIManager
