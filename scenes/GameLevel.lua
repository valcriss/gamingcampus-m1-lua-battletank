local Scene        = require "models.scenes.Scene"
local GameLevelOne = require "scenes.models.gamelevel.leveldata.GameLevelOne"
local LevelGrid    = require "scenes.models.gamelevel.grid.LevelGrid"
local Fps          = require "models.tools.Fps"
local PlayerTank   = require "scenes.models.gamelevel.unit.PlayerTank"

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
    local moveSpeed = 300

    -- ---------------------------------------------
    -- Ajout des composants
    -- ---------------------------------------------

    gameLevel.addComponent(levelGrid)
    gameLevel.addComponent(fps)
    gameLevel.addComponent(playerTank)

    function gameLevel.update(dt)
        local viewPortPosition = levelGrid.getViewPortPosition()

        if love.keyboard.isDown("w") or love.keyboard.isDown("z") then
            viewPortPosition.y = viewPortPosition.y - (moveSpeed * dt)
        end
        if love.keyboard.isDown("s") then
            viewPortPosition.y = viewPortPosition.y + (moveSpeed * dt)
        end
        if love.keyboard.isDown("a") or love.keyboard.isDown("q") then
            viewPortPosition.x = viewPortPosition.x - (moveSpeed * dt)
        end
        if love.keyboard.isDown("d") then
            viewPortPosition.x = viewPortPosition.x + (moveSpeed * dt)
        end
        levelGrid.setViewPortPosition(viewPortPosition.x, viewPortPosition.y)
        local viewPortDrawPosition = levelGrid.getViewPortDrawPosition()
        playerTank.setPosition(viewPortDrawPosition.x, viewPortDrawPosition.y, 0)
    end

    return gameLevel
end

return GameLevel
