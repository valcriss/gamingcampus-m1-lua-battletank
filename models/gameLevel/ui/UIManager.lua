local Component      = require "framework.scenes.Component"
local TowerStatusUI  = require "models.gameLevel.ui.TowerStatusUI"
local PlayerStatusUI = require "models.gameLevel.ui.PlayerStatusUI"

---@class UIManager
UIManager            = {}

---@param gameManager GameManager
UIManager.new        = function(gameManager)

    local uiManager = Component.new("UIManager")

    setmetatable(uiManager, UIManager)
    UIManager.__index    = UIManager

    local towerStatusUI  = TowerStatusUI.new("TowerStatusUI", gameManager)
    local playerStatusUI = PlayerStatusUI.new("PlayerStatusUI", gameManager, "left", 1)
    local enemyStatusUI  = PlayerStatusUI.new("EnemyStatusUI", gameManager, "right", 2)

    uiManager.addComponent(towerStatusUI)
    uiManager.addComponent(playerStatusUI)
    uiManager.addComponent(enemyStatusUI)

    function uiManager.load()
        gameManager.registerOnFlagCapturedEventHandler(uiManager.onFlagCaptured)
        gameManager.registerOnUnitUnderAttackEventHandler(uiManager.onUnitUnderAttack)
    end

    function uiManager.onFlagCaptured(unit, fromGroup)
        towerStatusUI.setFlagCaptured(unit, fromGroup)
    end

    function uiManager.onUnitUnderAttack(unit, damage, fromGroup)
        if unit.getType() ~= "Flag" then return end
        towerStatusUI.setUnitUnderAttack(unit, damage, fromGroup)
    end

    return uiManager
end

return UIManager
