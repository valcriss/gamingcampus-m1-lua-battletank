local Component      = require "framework.scenes.Component"
local Notification   = require "models.gameLevel.notifications.Notification"

---@class GameNotification
GameNotification     = {}

GameNotification.new = function(gameManager)
    local gameNotification = Component.new("GameNotification")

    setmetatable(gameNotification, GameNotification)
    GameNotification.__index = GameNotification

    local notification       = Notification.new(20, 700)
    gameNotification.addComponent(notification)

    local notificationDuration = 2
    local activeNotifications  = {}

    function gameNotification.load()
        gameManager.registerOnUnitUnderAttackEventHandler(gameNotification.onUnitUnderAttack)
        gameManager.registerOnFlagCapturedEventHandler(gameNotification.onFlagCaptured)
        gameManager.registerOnTowerFlagEventHandler(gameNotification.onTowerEvent)
    end

    function gameNotification.update(dt)
        for key, _ in pairs(activeNotifications) do
            activeNotifications[key] = activeNotifications[key] - dt
            if activeNotifications[key] <= 0 then
                activeNotifications[key] = nil
            end
        end
    end

    function gameNotification.onUnitUnderAttack(unit, _, fromGroup)
        if fromGroup == 2 and unit.getType() == "Flag" then
            local key = "attack-" .. unit.name
            if not activeNotifications[key] then
                activeNotifications[key] = notificationDuration
                notification.appear("L'enemie attaque la tour " .. unit.getIndex() .. " !")
            end
        end
        if fromGroup == 2 and unit.getType() == "MainTower" then
            local key = "attack-" .. unit.name
            if not activeNotifications[key] then
                activeNotifications[key] = notificationDuration
                notification.appear("L'enemie attaque votre tourelle !")
            end
        end
    end

    function gameNotification.onFlagCaptured(unit, fromGroup)
        if fromGroup == 2 then
            local key = "captured-" .. unit.name
            if not activeNotifications[key] then
                activeNotifications[key] = notificationDuration
                notification.appear("L'enemie a capture la tour " .. unit.getIndex() .. " !")
            end
        end
    end

    function gameNotification.onTowerEvent(tower, status)
        local key = "tower-" .. tower.name .. "-status"
        if not activeNotifications[key] then
            --activeNotifications[key] = notificationDuration
            if tower.getGroup() == 1 and status == "off" then
                notification.appear("Vous n'avez plus de bouclier !")
            end
            if tower.getGroup() == 1 and status == "on" then
                notification.appear("Vous avez retrouver votre bouclier !")
            end
            if tower.getGroup() == 2 and status == "off" then
                notification.appear("L'enemie n'a plus de bouclier !")
            end
            if tower.getGroup() == 2 and status == "on" then
                notification.appear("L'enemie a retrouver son bouclier !")
            end
        end
    end

    return gameNotification
end

return GameNotification
