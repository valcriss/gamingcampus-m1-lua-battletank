---@class FogOfWar
FogOfWar     = {}

FogOfWar.new = function(sight, gameLevelData)
    sight = sight or 7
    local fogOfWar = {
        gameLevelData = gameLevelData,
        sight         = sight,
        inSight       = {},
        seen          = {},
        seenDuration  = 10
    }

    setmetatable(fogOfWar, FogOfWar)
    FogOfWar.__index = FogOfWar

    function fogOfWar.isTileSeen(tilePosition)
        local tile = fogOfWar.gameLevelData.getTileIndex(tilePosition)
        return fogOfWar.seen["seen_" .. tostring(tile)]
    end

    function fogOfWar.isTileInSight(tilePosition)
        local tile = fogOfWar.gameLevelData.getTileIndex(tilePosition)
        return fogOfWar.inSight["inSight_" .. tostring(tile)] ~= nil
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

    function fogOfWar.updateFog(dt, position)
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

    function fogOfWar.distance(x1, y1, x2, y2)
        return math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
    end

    return fogOfWar
end

return FogOfWar
