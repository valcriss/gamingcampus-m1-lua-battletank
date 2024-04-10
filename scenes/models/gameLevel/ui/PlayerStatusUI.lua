local Component    = require "models.scenes.Component"
local Image        = require "models.images.Image"
local BitmapText   = require "models.texts.BitmapText"

---@class PlayerStatusUI
PlayerStatusUI     = {}

PlayerStatusUI.new = function(name, gameManager, position)
    local playerStatusUI = Component.new(name)

    setmetatable(playerStatusUI, PlayerStatusUI)
    PlayerStatusUI.__index       = PlayerStatusUI

    local playerStatusBackground = Image.new(playerStatusUI.name .. "_playerStatusBackground", "assets/gameLevel/ui/statusUI.png", 0, 0, nil, 1)
    local title                  = BitmapText.new(playerStatusUI.name .. "_title", "assets/ui/ui-18.fnt", "--", position, "top")

    playerStatusUI.addComponent(playerStatusBackground)
    playerStatusUI.addComponent(title)

    function playerStatusUI.load()
        title.bounds.y = 5
        if position == "left" then
            title.data.content      = "Joueur"
            title.bounds.x          = 10
            playerStatusUI.bounds.x = 151
            playerStatusUI.bounds.y = 25
        else
            title.data.content      = "Ordinateur"
            title.bounds.x          = screenManager:getWindowWidth() - 10
            playerStatusUI.bounds.x = screenManager:getWindowWidth() - 151
            playerStatusUI.bounds.y = 25
        end
        playerStatusBackground.bounds.x = playerStatusUI.bounds.x
        playerStatusBackground.bounds.y = playerStatusUI.bounds.y
    end

    return playerStatusUI
end

return PlayerStatusUI
