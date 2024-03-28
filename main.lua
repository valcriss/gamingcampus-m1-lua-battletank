-- Importation des modules
local ScreenManager = require "models.screen.ScreenManager"
local ScenesManager = require "models.scenes.ScenesManager"
SplashScreen = require "scenes.SplashScreen"
MainMenu = require "scenes.MainMenu"

if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

io.stdout:setvbuf "no"
love.window.setTitle("Daniel Silvestre - Programmation fondamentale LUA et Love2 - Battle Tank")
-- Déclaration des variables globales
screenManager = ScreenManager:new()
scenesManager = ScenesManager:new()

-- Déclaration des variables locales
local splashScreen = nil

-- Functions
function love.load()
    screenManager:init(1366, 768)
    splashScreen = SplashScreen.new(10)
    scenesManager:addScene(splashScreen)
end

function love.update(dt)
    scenesManager:update(dt)
end

function love.draw()
    scenesManager:draw()
end

function love.resize(_, _)
    screenManager:resize()
end
