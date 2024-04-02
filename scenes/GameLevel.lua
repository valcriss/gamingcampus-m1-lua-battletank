local Scene        = require "models.scenes.Scene"
local GameLevelOne = require "scenes.models.gamelevel.leveldata.GameLevelOne"
local LevelGrid    = require "scenes.models.gamelevel.grid.LevelGrid"
local Fps          = require "models.tools.Fps"
local PlayerTank   = require "scenes.models.gamelevel.unit.PlayerTank"
local Parallax     = require "models.images.Parallax"

---@class GameLevel
GameLevel          = {}

function GameLevel:getLevelData()
    if configuration.getLevel() == 1 then return GameLevelOne.new() end
    return nil
end

GameLevel.new = function()
    local gameLevel = Scene.new("GameLevel", 0)

    setmetatable(gameLevel, GameLevel)
    GameLevel.__index   = GameLevel

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    --- @type Fps
    local fps           = Fps.new("fps", 10, 10, { r = 1, g = 0, b = 0, a = 1 })
    --- @type GameLevelData
    local gameLevelData = GameLevel:getLevelData().load()
    --- @type LevelGrid
    local levelGrid     = LevelGrid.new("levelGrid", gameLevelData)
    --- @type PlayerTank
    local playerTank    = PlayerTank.new()
    --- @type number
    local moveSpeed     = 600
    local water         = Parallax.new("water", "assets/gamelevel/water.png", 100)
    -- ---------------------------------------------
    -- Ajout des composants
    -- ---------------------------------------------

    gameLevel.addComponent(water)
    gameLevel.addComponent(levelGrid)
    gameLevel.addComponent(fps)
    gameLevel.addComponent(playerTank)

    function gameLevel.update(dt)
        local update = gameLevel.updateInput(dt)
        levelGrid.setViewPortPosition(update.position.x, update.position.y)
        playerTank.setPosition(screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), update.rotation)
    end

    function gameLevel.updateInput(dt)
        local viewPortPosition = levelGrid.getViewPortPosition()
        local initialViewPortPosition = levelGrid.getViewPortPosition()
        local rotation         = playerTank.rotation

        if love.keyboard.isDown("w") or love.keyboard.isDown("z") then
            viewPortPosition.y = viewPortPosition.y - (moveSpeed * dt)
            rotation           = 180
        end
        if love.keyboard.isDown("s") then
            viewPortPosition.y = viewPortPosition.y + (moveSpeed * dt)
            rotation           = 0
        end
        if love.keyboard.isDown("a") or love.keyboard.isDown("q") then
            viewPortPosition.x = viewPortPosition.x - (moveSpeed * dt)
            rotation           = 90
        end
        if love.keyboard.isDown("d") then
            viewPortPosition.x = viewPortPosition.x + (moveSpeed * dt)
            rotation           = -90
        end
        if love.keyboard.isDown("s") and love.keyboard.isDown("d") then
            rotation = -45
        end
        if love.keyboard.isDown("s") and (love.keyboard.isDown("a") or love.keyboard.isDown("q")) then
            rotation = 45
        end
        if (love.keyboard.isDown("w") or love.keyboard.isDown("z")) and love.keyboard.isDown("d") then
            rotation = -135
        end
        if (love.keyboard.isDown("w") or love.keyboard.isDown("z")) and (love.keyboard.isDown("a") or love.keyboard.isDown("q")) then
            rotation = 135
        end

        local tileBlocked = levelGrid.isTileBlocked(viewPortPosition, rotation)
        if tileBlocked == true then
            print("RESET POSITION")
            viewPortPosition = initialViewPortPosition
        end

        return { position = viewPortPosition, rotation = rotation }
    end

    return gameLevel
end

return GameLevel
