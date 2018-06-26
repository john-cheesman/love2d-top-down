class = require 'lib.middleclass'
Stateful = require 'lib.stateful'
sti = require 'lib.sti.sti'
Vector = require 'lib.hump.vector'
inspect = require 'lib.inspect'
bump = require 'lib.bump'
beholder = require 'lib.beholder'
cargo = require 'lib.cargo'
camera = require 'lib.hump.camera'
Timer = require 'lib.hump.timer'
anim8 = require 'lib.anim8'
utility = require 'src.utility'
settings = require 'src.settings'

assets = cargo.init('assets')
screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

require 'src.game'

local game

function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    game = Game()
end

function love.draw()
    game:baseDraw()
end

function love.update(dt)
    game:baseUpdate(dt)
    Timer.update(dt)
end

function love.keypressed(key, code)
    game:baseKeypressed(key, code)
end

function love.joystickreleased(joystick, button)
    game:baseJoystickreleased(joystick, button)
end
