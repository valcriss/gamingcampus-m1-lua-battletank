local Component      = require "models.scenes.Component"
local TowerStatusUI  = require "scenes.models.gameLevel.ui.TowerStatusUI"
local PlayerStatusUI = require "scenes.models.gameLevel.ui.PlayerStatusUI"

---@class UIManager
UIManager            = {}

---@param gameManager GameManager
UIManager.new        = function(gameManager)

    local uiManager = Component.new("UIManager")

    setmetatable(uiManager, UIManager)
    UIManager.__index    = UIManager

    local towerStatusUI  = TowerStatusUI.new("TowerStatusUI", gameManager)
    local playerStatusUI = PlayerStatusUI.new("PlayerStatusUI", gameManager, "left")
    local enemyStatusUI  = PlayerStatusUI.new("EnemyStatusUI", gameManager, "right")
    
    uiManager.addComponent(towerStatusUI)
    uiManager.addComponent(playerStatusUI)
    uiManager.addComponent(enemyStatusUI)

    function uiManager.load()
        gameManager.registerOnFlagCapturedEventHandler(uiManager.onFlagCaptured)
    end

    function uiManager.onFlagCaptured(unit, fromGroup)
        towerStatusUI.setFlagCaptured(unit, fromGroup)
    end

    return uiManager
end

return UIManager
