---@class FogOfWar
FogOfWar     = {}

---@param sight number
---@param gameLevelData GameLevelData
FogOfWar.new = function(sight, gameLevelData)
    sight          = sight or 7
    local fogOfWar = {
        gameLevelData = gameLevelData,
        sight         = sight,
        inSight       = {},
        seen          = {},
        seenDuration  = 10,
        clipTop       = nil,
        clipRight     = nil,
        clipBottom    = nil,
        clipLeft      = nil,
    }

    setmetatable(fogOfWar, FogOfWar)
    FogOfWar.__index = FogOfWar

    function fogOfWar.isTileSeen(tilePosition)
        local tileIndex = fogOfWar.gameLevelData.getTileIndex(tilePosition)
        return fogOfWar.isTileSeenByIndex(tileIndex)
    end

    function fogOfWar.isTileSeenByIndex(tileIndex)
        return fogOfWar.seen["seen_" .. tostring(tileIndex)]
    end

    function fogOfWar.isTileInSight(tilePosition)
        local tileIndex = fogOfWar.gameLevelData.getTileIndex(tilePosition)
        return fogOfWar.isTileInSightByIndex(tileIndex)
    end

    function fogOfWar.isTileInSightByIndex(tileIndex)
        return fogOfWar.inSight["inSight_" .. tostring(tileIndex)] ~= nil
    end

    function fogOfWar.draw(x, y, realX, realY)
        local tilePosition = fogOfWar.gameLevelData.getGridPosition(realX, realY)
        local seen         = fogOfWar.isTileSeen(tilePosition)
        local inSight      = fogOfWar.isTileInSight(tilePosition)

        if inSight then return end
        if not seen then
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.rectangle("fill", screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), screenManager:ScaleValueX(fogOfWar.gameLevelData.tileSize), screenManager:ScaleValueY(fogOfWar.gameLevelData.tileSize))
            love.graphics.setColor(1, 1, 1, 1)
        end
        if not inSight and seen ~= nil then
            local alpha = 0.5 + fogOfWar.lerp(0, 0.5, seen / fogOfWar.seenDuration)
            love.graphics.setColor(0, 0, 0, alpha)
            love.graphics.rectangle("fill", screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), screenManager:ScaleValueX(fogOfWar.gameLevelData.tileSize), screenManager:ScaleValueY(fogOfWar.gameLevelData.tileSize))
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    function fogOfWar.lerp(a, b, t)
        return a + (b - a) * t
    end

    function fogOfWar.drawClip()
        love.graphics.setColor(0, 0, 0, 1)
        if (fogOfWar.clipLeft ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(fogOfWar.clipLeft.x), screenManager:ScaleValueY(fogOfWar.clipLeft.y), screenManager:ScaleValueX(fogOfWar.clipLeft.width), screenManager:ScaleValueY(fogOfWar.clipLeft.height))
        end
        if (fogOfWar.clipTop ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(fogOfWar.clipTop.x), screenManager:ScaleValueY(fogOfWar.clipTop.y), screenManager:ScaleValueX(fogOfWar.clipTop.width), screenManager:ScaleValueY(fogOfWar.clipTop.height))
        end
        if (fogOfWar.clipRight ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(fogOfWar.clipRight.x), screenManager:ScaleValueY(fogOfWar.clipRight.y), screenManager:ScaleValueX(fogOfWar.clipRight.width), screenManager:ScaleValueY(fogOfWar.clipRight.height))
        end
        if (fogOfWar.clipBottom ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(fogOfWar.clipBottom.x), screenManager:ScaleValueY(fogOfWar.clipBottom.y), screenManager:ScaleValueX(fogOfWar.clipBottom.width), screenManager:ScaleValueY(fogOfWar.clipBottom.height))
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    function fogOfWar.updateFog(dt, position)
        fogOfWar.updateClipBounds(position)
        local distSeen    = ((fogOfWar.sight + 1) * fogOfWar.gameLevelData.tileSize)
        local distInSight = ((fogOfWar.sight) * fogOfWar.gameLevelData.tileSize)
        local xMin        = position.x - distSeen
        local yMin        = position.y - distSeen
        local xMax        = position.x + distSeen
        local yMax        = position.y + distSeen

        fogOfWar.inSight  = {}

        while xMin <= xMax do
            while yMin <= yMax do
                -- ---------------------------------
                local tile     = fogOfWar.gameLevelData.getTileIndexFromRealPosition(xMin, yMin)
                local distance = fogOfWar.distance(position.x, position.y, xMin, yMin)
                if (distance <= distInSight) then
                    fogOfWar.inSight["inSight_" .. tostring(tile)] = true
                end
                if (distance <= distSeen) then
                    fogOfWar.seen["seen_" .. tostring(tile)] = 0
                end
                -- ---------------------------------
                yMin = yMin + fogOfWar.gameLevelData.tileSize
            end
            xMin = xMin + fogOfWar.gameLevelData.tileSize
            yMin = position.y - distSeen
        end

        for key, value in pairs(fogOfWar.seen) do
            fogOfWar.seen[key] = value + dt
            if (fogOfWar.seen[key] > fogOfWar.seenDuration) then
                fogOfWar.seen[key] = nil
            end
        end
    end

    function fogOfWar.updateClipBounds(position)
        local mapWidth   = (fogOfWar.gameLevelData.tileSize * fogOfWar.gameLevelData.level.Width)
        local mapHeight  = (fogOfWar.gameLevelData.tileSize * fogOfWar.gameLevelData.level.Height)
        local midScreenX = (screenManager:getWindowWidth() / 2)
        local midScreenY = (screenManager:getWindowHeight() / 2)
        local left       = (midScreenX + (((position.x - (mapWidth)) + mapWidth) * -1)) - (fogOfWar.gameLevelData.tileSize / 2)
        local top      = (midScreenY + (((position.y - (mapHeight)) + mapHeight) * -1)) - (fogOfWar.gameLevelData.tileSize / 2)
        local right = (position.x -mapWidth) + (fogOfWar.gameLevelData.tileSize / 2) + midScreenX
        local bottom = (position.y -mapHeight) + (fogOfWar.gameLevelData.tileSize / 2) + midScreenY

        if (left > 0) then
            fogOfWar.clipLeft = { x = 0, y = 0, width = left, height = screenManager:getWindowHeight() }
        else
            fogOfWar.clipLeft = nil
        end
        if (top > 0) then
            fogOfWar.clipTop = { x = 0, y = 0, width = screenManager:getWindowWidth(), height = top }
        else
            fogOfWar.clipTop = nil
        end
        if (right > 0) then
            fogOfWar.clipRight = { x = screenManager:getWindowWidth() - right, y = 0, width = right, height = screenManager:getWindowHeight() }
        else
            fogOfWar.clipRight = nil
        end
        if (bottom > 0) then
            fogOfWar.clipBottom = { x = 0, y = screenManager:getWindowHeight() - bottom, width = screenManager:getWindowWidth(), height = bottom }
        else
            fogOfWar.clipBottom = nil
        end
    end

    function fogOfWar.distance(x1, y1, x2, y2)
        return math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
    end

    return fogOfWar
end

return FogOfWar
