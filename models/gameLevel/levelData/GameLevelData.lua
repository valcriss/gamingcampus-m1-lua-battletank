local JsonAsset   = require "framework.tools.JsonAsset"
local Component   = require "framework.scenes.Component"
local Vector2     = require "framework.drawing.Vector2"

---@class GameLevelData
GameLevelData     = {}

GameLevelData.new = function()
    local gameLevelData = Component.new("GameLevelData")

    setmetatable(gameLevelData, GameLevelData)
    GameLevelData.__index = GameLevelData

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type table
    local level           = {}
    ---@type table
    local tiles           = {}

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    ---@return table
    function gameLevelData.getLevel()
        return level
    end

    ---@public
    ---@return table
    function gameLevelData.getTiles()
        return tiles
    end

    ---@public
    --- Retounne les cellules adjacentes à la cellule passée en paramètre
    ---@param index number
    ---@return table
    function gameLevelData.getNeighbors(index)
        local neighbors = {}
        --- Normals
        local topIndex  = index - level.Width
        if topIndex >= 1 and not gameLevelData.isTileBlocked(topIndex) and not gameLevelData.isTileBlocked(topIndex) then
            neighbors["top"] = topIndex
        end
        local bottomIndex = index + level.Width
        if bottomIndex <= level.Width * level.Height and not gameLevelData.isTileBlocked(bottomIndex) then
            neighbors["bottom"] = bottomIndex
        end
        local leftIndex = index - 1
        if leftIndex % level.Width ~= 0 and not gameLevelData.isTileBlocked(leftIndex) then
            neighbors["left"] = leftIndex
        end
        local rightIndex = index + 1
        if rightIndex % level.Width ~= 0 and not gameLevelData.isTileBlocked(rightIndex) then
            neighbors["right"] = rightIndex
        end
        --- Diagonals
        local topRightIndex = (index - level.Width) + 1
        if topRightIndex >= 1 and topRightIndex % level.Width ~= 0 and not gameLevelData.isTileBlocked(topRightIndex) and not gameLevelData.isTileBlocked(topIndex) and not gameLevelData.isTileBlocked(rightIndex) then
            neighbors["topRight"] = topRightIndex
        end
        local topLeftIndex = (index - level.Width) - 1
        if topLeftIndex >= 1 and topLeftIndex % level.Width ~= 0 and not gameLevelData.isTileBlocked(topLeftIndex) and not gameLevelData.isTileBlocked(topIndex) and not gameLevelData.isTileBlocked(leftIndex) then
            neighbors["topLeft"] = topLeftIndex
        end
        local bottomRightIndex = (index + level.Width) + 1
        if bottomRightIndex <= level.Width * level.Height and bottomRightIndex % level.Width ~= 0 and not gameLevelData.isTileBlocked(bottomIndex) and not gameLevelData.isTileBlocked(bottomRightIndex) and not gameLevelData.isTileBlocked(rightIndex) then
            neighbors["bottomRight"] = bottomRightIndex
        end
        local bottomLeftIndex = (index + level.Width) - 1
        if bottomLeftIndex <= level.Width * level.Height and bottomLeftIndex % level.Width ~= 0 and not gameLevelData.isTileBlocked(bottomIndex) and not gameLevelData.isTileBlocked(bottomLeftIndex) and not gameLevelData.isTileBlocked(leftIndex) then
            neighbors["bottomLeft"] = bottomLeftIndex
        end

        return neighbors
    end

    ---@public
    --- Fonction qui charge les données du niveau dans la variable level et charge les images necessaires pour les tiles
    function gameLevelData.load()
        local levelAsset = gameLevelData.getLevelAsset()
        level            = JsonAsset:load(levelAsset)
        for key, value in pairs(level.TilesAssets) do
            tiles[key] = love.graphics.newImage(value)
        end
    end

    ---@public
    --- Fonction qui retourne l'index de la tile correspondant à la position passeée en paramètre
    ---@param realX number
    ---@param realY number
    ---@return number
    function gameLevelData.getTileIndexFromRealPosition(realX, realY)
        local position = gameLevelData.getGridPosition(realX, realY)
        return gameLevelData.getTileIndex(position.x, position.y)
    end

    ---@public
    --- Fonction qui retourne l'index de la tile correspondant à la position passeée en paramètre
    ---@param gridX number
    ---@param gridY number
    ---@return number
    function gameLevelData.getTileIndex(gridX, gridY)
        local index = ((gridY - 1) * level.Width) + gridX
        if index < 1 or index > level.Width * level.Height then return nil end
        return index
    end

    ---@public
    --- Fonction qui retourne la position de la tile correspondant à la position passeée en paramètre
    ---@param realX number
    ---@param realY number
    ---@return { x: number, y: number }
    function gameLevelData.getGridPosition(realX, realY)
        return {
            x = math.floor(realX / level.TileSize) + 1,
            y = math.floor(realY / level.TileSize) + 1
        }
    end

    ---@public
    --- Fonction qui retourne l'index de l'image correspondant à l'index de la tile
    ---@param tileIndex number
    ---@param layer number
    ---@return number
    function gameLevelData.getImageIndexFromTileIndex(tileIndex, layer)
        return level["Layer" .. tostring(layer)]["cell_" .. tostring(tileIndex)]
    end

    ---@public
    --- Fonction qui retourne si la cellule correspondant à l'index de la tile est bloquee
    ---@param tileIndex number
    ---@return boolean
    function gameLevelData.isTileBlocked(tileIndex)
        return level["Block"]["block_" .. tostring(tileIndex)] == true
    end

    ---@public
    --- Fonction qui retourne si la cellule correspondant à l'index de la tile est bloquee par un element de l'environnement
    ---@param tileIndex number
    ---@return boolean
    function gameLevelData.isTileEnvironmentBlocked(tileIndex)
        return level["Layer1"]["cell_" .. tostring(tileIndex)] ~= nil and gameLevelData.isTileBlocked(tileIndex)
    end

    ---@public
    --- Fonction qui retourne si la cellule correspondant aux coordonnes de la tile est bloquee
    function gameLevelData.isTileBlockedFromGridPosition(gridPosition)
        local tileIndex = gameLevelData.getTileIndex(gridPosition.x, gridPosition.y)
        return gameLevelData.isTileBlocked(tileIndex)
    end

    ---@public
    --- Fonction qui retourne la position de la base principale du joueur ou de l'ennemi
    ---@return Vector2
    function gameLevelData.getMainTowerWorldPosition(group)
        if group == 1 then
            return gameLevelData.getPlayerMainTowerWorldPosition()
        else
            return gameLevelData.getEnemyMainTowerWorldPosition()
        end
    end

    ---@public
    --- Fonction qui retourne la position de la base principale du joueur
    ---@return Vector2
    function gameLevelData.getPlayerMainTowerWorldPosition()
        return gameLevelData.translateGridPositionToWorldPosition(level.PlayerBase.x, level.PlayerBase.y)
    end

    ---@public
    --- Fonction qui retourne la position de la base principale de l'ennemi
    ---@return Vector2
    function gameLevelData.getEnemyMainTowerWorldPosition()
        return gameLevelData.translateGridPositionToWorldPosition(level.EnemyBase.x, level.EnemyBase.y)
    end

    ---@public
    --- Fonction qui transforme les coordonnes de la tile en coordonnes du monde
    ---@param x number
    ---@param y number
    ---@return Vector2
    function gameLevelData.translateGridPositionToWorldPosition(x, y)
        return Vector2.new((x - 1) * level.TileSize, (y - 1) * level.TileSize)
    end

    ---@public
    --- Fonction qui retourne les coordonées du monde correspondant à l'index de la tile
    ---@param tileIndex number
    ---@return Vector2
    function gameLevelData.getRealPositionFromTileIndex(tileIndex)
        local gridPosition = gameLevelData.getGridPositionFromTileIndex(tileIndex)
        return gameLevelData.translateGridPositionToWorldPosition(gridPosition.x, gridPosition.y)
    end

    ---@public
    --- Fonction qui retourne les coordonnees du monde correspondant à l'index de la tile
    ---@param tileIndex number
    ---@return Vector2
    function gameLevelData.getGridPositionFromTileIndex(tileIndex)
        local x = (tileIndex - 1) % level.Width + 1
        local y = math.floor((tileIndex - 1) / level.Width) + 1
        return Vector2.new(x, y)
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    ---@private
    --- Retourne l'asset du niveau correspondant au niveau courant
    ---@return string
    function gameLevelData.getLevelAsset()
        if configuration.getLevel() == 1 then return "assets/gameLevel/levels/level1.json" end
        if configuration.getLevel() == 2 then return "assets/gameLevel/levels/level2.json" end
        if configuration.getLevel() == 3 then return "assets/gameLevel/levels/level3.json" end
        return nil
    end

    return gameLevelData
end

return GameLevelData
