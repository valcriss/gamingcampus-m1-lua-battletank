local DIRECT_TO_MAP = true

-- Importation des modules
local ScreenManager = require "models.screen.ScreenManager"
local ScenesManager = require "models.scenes.ScenesManager"
local Configuration = require "models.configuration.Configuration"
local SplashScreen  = require "scenes.SplashScreen"
local GameLevel     = require "scenes.GameLevel"

if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

io.stdout:setvbuf "no"
love.window.setTitle("Daniel Silvestre - Programmation fondamentale LUA et Love2 - Battle Tank")
-- Déclaration des variables globals
FOG_OF_WAR    = true

configuration = Configuration:new()
screenManager = ScreenManager:new()
scenesManager = ScenesManager:new()

-- Déclaration des variables locales
-- local splashScreen
--local gameLevel
-- love.graphics.setDefaultFilter("nearest")
-- Functions
function love.load()
    configuration:load()
    screenManager:init(1366, 768)
    if DIRECT_TO_MAP then
        local gameLevel = GameLevel.new()
        scenesManager:addScene(gameLevel)
    else
        local splashScreen = SplashScreen.new(4)
        scenesManager:addScene(splashScreen)
    end
end

function love.update(dt)
    scenesManager:update(dt)
end

function love.draw()
    scenesManager:draw()
end

function love.resize(_, _)
    configuration:setMaximized(love.window.isMaximized())
    screenManager:resize()
end

function love.keypressed(key, _, _)
    if key == "escape" or key == "p" then
        scenesManager:togglePause()
    end
end

