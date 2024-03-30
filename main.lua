-- Importation des modules
local ScreenManager = require "models.screen.ScreenManager"
local ScenesManager = require "models.scenes.ScenesManager"
local Configuration = require "models.configuration.Configuration"
SplashScreen = require "scenes.SplashScreen"
MainMenu = require "scenes.MainMenu"

if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

io.stdout:setvbuf "no"
love.window.setTitle("Daniel Silvestre - Programmation fondamentale LUA et Love2 - Battle Tank")
-- Déclaration des variables globales
configuration = Configuration:new()
screenManager = ScreenManager:new()
scenesManager = ScenesManager:new()

-- Déclaration des variables locales
local splashScreen

-- Functions
function love.load()
    configuration:load()
    screenManager:init(1366, 768)
    splashScreen = SplashScreen.new(4)
    scenesManager:addScene(splashScreen)
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
