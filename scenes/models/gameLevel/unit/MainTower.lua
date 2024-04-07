local Component        = require "models.scenes.Component"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local Image            = require "models.images.Image"
local Rectangle        = require "models.drawing.Rectangle"
---@class MainTower
MainTower              = {}

---@param name string
---@param x number
---@param y number
---@param gameLevelData GameLevelData
---@param levelGrid LevelGrid
MainTower.new          = function(name, assetPath, cellX, cellY, gameLevelData, levelGrid, group)
    local mainTower = Component.new(
            name,
            {
                gameLevelData = gameLevelData,
                levelGrid     = levelGrid,
                tilePosition  = { x = cellX, y = cellY },
                wasVisible    = true,
                mustBeVisible = true,
                shieldActive  = true,
                realBounds    = nil,
                unitType      = "MainTower",
                unitGroup     = group,
                gunRotation   = 0
            }
    )

    local tower     = Image.new(mainTower.name .. "_tower", "assets/gamelevel/tower.png", 12, 1, 0, 0.5)
    local gun       = Image.new(mainTower.name .. "_tower", assetPath, 12, 1, 0, 0.5)
    local bouclier  = SpriteSheetImage.new(mainTower.name .. "_bouclier", "assets/gamelevel/bouclier.png", 12, 1, 50, true, mainTower.bounds.x, mainTower.bounds.y, nil, nil, 0, 0.25)

    setmetatable(mainTower, MainTower)
    MainTower.__index = MainTower

    mainTower.addComponent(tower)
    mainTower.addComponent(gun)
    mainTower.addComponent(bouclier)

    function mainTower.update(dt)
        local realPosition = mainTower.data.gameLevelData.getRealPosition(mainTower.data.tilePosition.x, mainTower.data.tilePosition.y)
        local drawViewPort = mainTower.data.levelGrid.getGridViewDrawViewPort()

        mainTower.bounds.x = (realPosition.x + drawViewPort.x) + mainTower.data.gameLevelData.tileSize / 2
        mainTower.bounds.y = (realPosition.y + drawViewPort.y) + mainTower.data.gameLevelData.tileSize / 2

        mainTower.updateAssetsBounds(realPosition)
        mainTower.updateGunRotation(dt, realPosition)
        mainTower.updateAssetsPosition()

        if mainTower.data.unitGroup == 2 then
            mainTower.data.shieldActive = false
        end

        mainTower.updateAssetsVisibility()
    end

    function mainTower.updateGunRotation(dt, realPosition)
        local distanceThreshold = 400
        local idleRotationSpeed = 10
        local fastRotationSpeed = 200
        local minDistance       = math.huge
        local targetUnit
        for _, unit in ipairs(gameUnits) do
            if unit.data.realBounds ~= nil and unit.data.unitType ~= nil and unit.data.unitType == "Tank" and unit.data.unitGroup ~= mainTower.data.unitGroup then
                local distance = mainTower.distance(unit.data.realBounds.x, unit.data.realBounds.y, realPosition.x, realPosition.y)
                if distance < distanceThreshold then
                    if distance < minDistance then
                        minDistance = distance
                        targetUnit  = unit.data.realBounds
                    end
                end
            end
        end

        if targetUnit ~= nil then
            local targetAngle = -math.deg(math.atan2(realPosition.y - targetUnit.y, targetUnit.x - realPosition.x)) + 90
            if targetAngle < 0 then targetAngle = targetAngle + 360 end
            if targetAngle > 360 then targetAngle = targetAngle - 360 end
            local angleMove = math.min(fastRotationSpeed * dt, math.abs(targetAngle - mainTower.data.gunRotation))
            if mainTower.data.gunRotation < targetAngle then
                mainTower.data.gunRotation = mainTower.data.gunRotation + angleMove
            else
                mainTower.data.gunRotation = mainTower.data.gunRotation - angleMove
            end
        else
            mainTower.data.gunRotation = mainTower.data.gunRotation + (idleRotationSpeed * dt)
        end
        if mainTower.data.gunRotation > 360 then mainTower.data.gunRotation = mainTower.data.gunRotation - 360 end
        if mainTower.data.gunRotation < 0 then mainTower.data.gunRotation = mainTower.data.gunRotation + 360 end
    end

    function mainTower.distance(x1, y1, x2, y2)
        return math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
    end

    function mainTower.updateAssetsPosition()
        tower.setPosition(mainTower.bounds.x, mainTower.bounds.y)
        gun.setPosition(mainTower.bounds.x, mainTower.bounds.y)
        gun.rotation = mainTower.data.gunRotation
        bouclier.setPosition(mainTower.bounds.x, mainTower.bounds.y)
    end

    function mainTower.updateAssetsBounds(realPosition)
        if mainTower.data.shieldActive == true then
            mainTower.bounds.width    = bouclier.bounds.width
            mainTower.bounds.height   = bouclier.bounds.height
            mainTower.data.realBounds = Rectangle.new(realPosition.x - (bouclier.bounds.width * bouclier.scale), realPosition.y - (bouclier.bounds.height * bouclier.scale), mainTower.bounds.width, mainTower.bounds.height)
        else
            mainTower.bounds.width    = tower.bounds.width * tower.scale
            mainTower.bounds.height   = tower.bounds.height * tower.scale
            mainTower.data.realBounds = Rectangle.new(realPosition.x, realPosition.y, mainTower.bounds.width, mainTower.bounds.height)
        end
    end

    function mainTower.updateAssetsVisibility()
        local seen = mainTower.data.levelGrid.data.fog.isTileSeen(mainTower.data.tilePosition)
        if seen ~= nil and mainTower.data.wasVisible == false then
            mainTower.data.mustBeVisible = true
            bouclier.show()
            gun.show()
            tower.show()
            mainTower.data.wasVisible = true
        elseif seen == nil and mainTower.data.wasVisible == true then
            bouclier.hide()
            gun.hide()
            tower.hide()
            mainTower.data.mustBeVisible = false
            mainTower.data.wasVisible    = false
        end

        if mainTower.data.mustBeVisible == true and mainTower.data.shieldActive == true and bouclier.visible == false then
            bouclier.show()
        end
        if mainTower.data.mustBeVisible == true and mainTower.data.shieldActive == false and bouclier.visible == true then
            bouclier.hide()
        end

    end

    return mainTower
end

return MainTower
