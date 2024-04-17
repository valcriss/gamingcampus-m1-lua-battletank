local Component         = require "models.scenes.Component"
local Image             = require "models.images.Image"
local BitmapText        = require "models.texts.BitmapText"
local MainTowerHeathBar = require "scenes.models.gameLevel.ui.MainTowerHeathBar"

---@class PlayerStatusUI
PlayerStatusUI          = {}

---@param name string
---@param gameManager GameManager
---@param position string
PlayerStatusUI.new      = function(name, gameManager, position, group)
    local playerStatusUI = Component.new(name)

    setmetatable(playerStatusUI, PlayerStatusUI)
    PlayerStatusUI.__index       = PlayerStatusUI

    local playerStatusBackground = Image.new(playerStatusUI.name .. "_playerStatusBackground", "assets/ui/statusUI.png", 0, 0, nil, 1)
    local title                  = BitmapText.new(playerStatusUI.name .. "_title", "assets/fonts/ui-18.fnt", "--", position, "top")
    local mainTowerHeathBar      = MainTowerHeathBar.new(playerStatusUI.name .. "_title", gameManager.getMainTowerByGroup(group))

    playerStatusUI.addComponent(playerStatusBackground)
    playerStatusUI.addComponent(title)
    playerStatusUI.addComponent(mainTowerHeathBar)

    function playerStatusUI.load()
        title.bounds.y = 5
        if group == 1 then
            title.setContent("Joueur")
            title.bounds.x             = 10
            playerStatusUI.bounds.x    = 151
            playerStatusUI.bounds.y    = 25
            mainTowerHeathBar.bounds.x = 10
            mainTowerHeathBar.bounds.y = 25
        else
            title.setContent("Ordinateur")
            title.bounds.x             = screenManager:getWindowWidth() - 10
            playerStatusUI.bounds.x    = screenManager:getWindowWidth() - 151
            playerStatusUI.bounds.y    = 25
            mainTowerHeathBar.bounds.x = screenManager:getWindowWidth() - 295
            mainTowerHeathBar.bounds.y = 25
        end
        playerStatusBackground.bounds.x = playerStatusUI.bounds.x
        playerStatusBackground.bounds.y = playerStatusUI.bounds.y
    end

    return playerStatusUI
end

return PlayerStatusUI
