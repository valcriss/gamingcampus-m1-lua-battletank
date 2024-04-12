local Unit      = require "scenes.models.gameLevel.game.entities.Unit"
local Rectangle = require "models.drawing.Rectangle"

---@class Player
Player          = {}

--- @param gameManager GameManager
Player.new      = function(gameManager)
    local player = Unit.new("Player", gameManager, "assets/gamelevel/tank-body.png", "assets/gamelevel/tank-turret.png", "assets/gamelevel/tank-turret-fire.png", screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), 1)

    setmetatable(player, Player)
    Player.__index = Player

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    player.setRegenHealthAmount(configuration:getPlayerRegenHealthAmount())
    player.setMaxHealth(configuration:getPlayerMaxHealth())
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function player.updateUnit(_)
        local mouseX, mouseY = love.mouse.getPosition()
        local worldPosition  = gameManager.getViewport().getRealPosition()
        player.setCollider(Rectangle.new(worldPosition.x, worldPosition.y, player.bounds.width, player.bounds.height).scale(player.scale))
        player.targetPosition(screenManager:ScaleUIValueX(mouseX), screenManager:ScaleUIValueY(mouseY))
        if love.mouse.isDown(1) then
            player.setStartRealPosition(worldPosition.offsetPosition(gameManager.getGameLevelData().data.level.TileSize / 2, gameManager.getGameLevelData().data.level.TileSize / 2))
            local mouseOffset = { x = screenManager:ScaleUIValueX(mouseX) - screenManager:calculateCenterPointX(), y = screenManager:ScaleUIValueY(mouseY) - screenManager:calculateCenterPointY() }
            player.setDestinationRealPosition({ x = worldPosition.x + mouseOffset.x, y = worldPosition.y + mouseOffset.y })
            player.fireStarts()
        end
    end

    function player.playerInputs(_, top, left, bottom, right)
        -- haut
        if (top == true and left == false and bottom == false and right == false) then
            player.setRotation(180)
            -- gauche
        elseif (top == false and left == true and bottom == false and right == false) then
            player.setRotation(90)
            -- bas
        elseif (top == false and left == false and bottom == true and right == false) then
            player.setRotation(0)
            -- droite
        elseif (top == false and left == false and bottom == false and right == true) then
            player.setRotation(270)
            -- bas droite
        elseif (top == false and left == false and bottom == true and right == true) then
            player.setRotation(315)
            -- bas gauche
        elseif (top == false and left == true and bottom == true and right == false) then
            player.setRotation(45)
            -- haut gauche
        elseif (top == true and left == true and bottom == false and right == false) then
            player.setRotation(135)
            -- haut droite
        elseif (top == true and left == false and bottom == false and right == true) then
            player.setRotation(225)
        end
    end

    return player
end

return Player
