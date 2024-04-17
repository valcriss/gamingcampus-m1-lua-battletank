local Component  = require "framework.scenes.Component"
local MathHelper = require "framework.tools.MathHelper"

---@class FogOfWar
FogOfWar         = {}

--- @param gameManager GameManager
FogOfWar.new     = function(gameManager, forgetTilesSeen)
    local fogOfWar = Component.new("FogOfWar")

    setmetatable(fogOfWar, FogOfWar)
    FogOfWar.__index   = FogOfWar

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local sight        = 7
    local inSight      = {}
    local seen         = {}
    local seenDuration = 10
    local clipTop
    local clipRight
    local clipBottom
    local clipLeft

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function fogOfWar.update(dt)
        local position = gameManager.getViewport().getRealPosition()
        fogOfWar.updateClipBounds(position)
        local distSeen    = ((sight + 1) * gameManager.getGameLevelData().getLevel().TileSize)
        local distInSight = ((sight) * gameManager.getGameLevelData().getLevel().TileSize)
        local xMin        = position.x - distSeen
        local yMin        = position.y - distSeen
        local xMax        = position.x + distSeen
        local yMax        = position.y + distSeen

        inSight           = {}

        while xMin <= xMax do
            while yMin <= yMax do
                -- ---------------------------------
                local tile     = gameManager.getGameLevelData().getTileIndexFromRealPosition(xMin, yMin)
                local distance = position.distance(xMin, yMin)
                if (distance <= distInSight) then
                    inSight["inSight_" .. tostring(tile)] = true
                end
                if (distance <= distSeen) then
                    seen["seen_" .. tostring(tile)] = 0
                end
                -- ---------------------------------
                yMin = yMin + gameManager.getGameLevelData().getLevel().TileSize
            end
            xMin = xMin + gameManager.getGameLevelData().getLevel().TileSize
            yMin = position.y - distSeen
        end

        if forgetTilesSeen ~= nil and forgetTilesSeen == true then
            for key, value in pairs(seen) do
                seen[key] = value + dt
                if (seen[key] > seenDuration) then
                    seen[key] = nil
                end
            end
        end
    end

    function fogOfWar.draw()
        local renderBounds = gameManager.getViewport().getRenderBounds()

        local x            = renderBounds.x
        local y            = renderBounds.y
        local vx           = 0
        local vy           = 0

        while x <= renderBounds.width do
            while y <= renderBounds.height do

                local tilePosition = gameManager.getGameLevelData().getGridPosition(vx, vy)
                if (tilePosition.x < 1 or tilePosition.y < 1 or tilePosition.x > gameManager.getGameLevelData().getLevel().Width or tilePosition.y > gameManager.getGameLevelData().getLevel().Height) then
                    break
                end

                if y >= -gameManager.getGameLevelData().getLevel().TileSize and x >= -gameManager.getGameLevelData().getLevel().TileSize then
                    fogOfWar.drawTile(x, y, tilePosition)
                end

                y  = y + gameManager.getGameLevelData().getLevel().TileSize
                vy = vy + gameManager.getGameLevelData().getLevel().TileSize
            end
            y  = renderBounds.y
            vy = 0
            x  = x + gameManager.getGameLevelData().getLevel().TileSize
            vx = vx + gameManager.getGameLevelData().getLevel().TileSize
        end
        fogOfWar.drawClip()
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------
    ---@private
    function fogOfWar.drawClip()
        love.graphics.setColor(0, 0, 0, 1)
        if (clipLeft ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(clipLeft.x), screenManager:ScaleValueY(clipLeft.y), screenManager:ScaleValueX(clipLeft.width), screenManager:ScaleValueY(clipLeft.height))
        end
        if (clipTop ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(clipTop.x), screenManager:ScaleValueY(clipTop.y), screenManager:ScaleValueX(clipTop.width), screenManager:ScaleValueY(clipTop.height))
        end
        if (clipRight ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(clipRight.x), screenManager:ScaleValueY(clipRight.y), screenManager:ScaleValueX(clipRight.width), screenManager:ScaleValueY(clipRight.height))
        end
        if (clipBottom ~= nil) then
            love.graphics.rectangle("fill", screenManager:ScaleValueX(clipBottom.x), screenManager:ScaleValueY(clipBottom.y), screenManager:ScaleValueX(clipBottom.width), screenManager:ScaleValueY(clipBottom.height))
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    ---@private
    function fogOfWar.drawTile(x, y, tilePosition)
        local isSeen    = fogOfWar.isTileSeen(tilePosition)
        local isInSight = fogOfWar.isTileInSight(tilePosition)

        if isInSight then return end
        if not isSeen then
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.rectangle("fill", screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), screenManager:ScaleValueX(gameManager.getGameLevelData().getLevel().TileSize), screenManager:ScaleValueY(gameManager.getGameLevelData().getLevel().TileSize))
            love.graphics.setColor(1, 1, 1, 1)
        end
        if not isInSight and isSeen ~= nil then
            local alpha = 0.3 + MathHelper:lerp(0, 0.7, isSeen / seenDuration)
            love.graphics.setColor(0, 0, 0, alpha)
            love.graphics.rectangle("fill", screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), screenManager:ScaleValueX(gameManager.getGameLevelData().getLevel().TileSize), screenManager:ScaleValueY(gameManager.getGameLevelData().getLevel().TileSize))
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    ---@private
    function fogOfWar.updateClipBounds(position)
        local mapWidth   = (gameManager.getGameLevelData().getLevel().TileSize * gameManager.getGameLevelData().getLevel().Width)
        local mapHeight  = (gameManager.getGameLevelData().getLevel().TileSize * gameManager.getGameLevelData().getLevel().Height)
        local midScreenX = (screenManager:getWindowWidth() / 2)
        local midScreenY = (screenManager:getWindowHeight() / 2)
        local left       = (midScreenX + (((position.x - (mapWidth)) + mapWidth) * -1)) - (gameManager.getGameLevelData().getLevel().TileSize / 2)
        local top        = (midScreenY + (((position.y - (mapHeight)) + mapHeight) * -1)) - (gameManager.getGameLevelData().getLevel().TileSize / 2)
        local right      = (position.x - mapWidth) + (gameManager.getGameLevelData().getLevel().TileSize / 2) + midScreenX
        local bottom     = (position.y - mapHeight) + (gameManager.getGameLevelData().getLevel().TileSize / 2) + midScreenY

        if (left > 0) then
            clipLeft = { x = 0, y = 0, width = left, height = screenManager:getWindowHeight() }
        else
            clipLeft = nil
        end
        if (top > 0) then
            clipTop = { x = 0, y = 0, width = screenManager:getWindowWidth(), height = top }
        else
            clipTop = nil
        end
        if (right > 0) then
            clipRight = { x = screenManager:getWindowWidth() - right, y = 0, width = right, height = screenManager:getWindowHeight() }
        else
            clipRight = nil
        end
        if (bottom > 0) then
            clipBottom = { x = 0, y = screenManager:getWindowHeight() - bottom, width = screenManager:getWindowWidth(), height = bottom }
        else
            clipBottom = nil
        end
    end

    function fogOfWar.isTileSeen(tilePosition)
        local tileIndex = gameManager.getGameLevelData().getTileIndex(tilePosition.x, tilePosition.y)
        if tileIndex == nil then return nil end
        return fogOfWar.isTileSeenByIndex(tileIndex)
    end

    function fogOfWar.isTileSeenByIndex(tileIndex)
        return seen["seen_" .. tostring(tileIndex)]
    end

    function fogOfWar.isTileInSight(tilePosition)
        local tileIndex = gameManager.getGameLevelData().getTileIndex(tilePosition.x, tilePosition.y)
        if tileIndex == nil then return nil end
        return fogOfWar.isTileInSightByIndex(tileIndex)
    end

    function fogOfWar.isTileInSightByIndex(tileIndex)
        return inSight["inSight_" .. tostring(tileIndex)] ~= nil
    end

    return fogOfWar
end

return FogOfWar
