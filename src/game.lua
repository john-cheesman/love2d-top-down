--- Base game singleton.
-- @classmod Game

Game = class('Game'):include(Stateful)

require 'src.states.world'
require 'src.entities.player'

--- Initialise a single gamepad if connected.
-- @treturn table A gamepad instance or nil
local function initGamepad()
    local gamepads = love.joystick.getJoysticks()
    if #gamepads > 0 then
        return gamepads[1]
    end

    return nil
end

--- Game constructor.
function Game:initialize()
    self.map = nil
    self.player = Player({ name = 'John', x = 0, y = 0, width = 26, height = 16, image = assets.dawn_like.Commissions.Paladin, xp = 100, baseStats = { str = 200, hp = 200, agt = 190, int = 80 } })
    self.overlay = { alpha = 1 }
    self.gamepad = initGamepad()

    self:gotoState('World', 'town')
end

--- Base update callback.
-- Shared updates for all Game states, including control event triggers and timer
-- @tparam number dt Time delta
function Game:baseUpdate(dt)
    local gamepadAxes = self.gamepad ~= nil and Vector(self.gamepad:getAxes()) or Vector()

    if love.keyboard.isDown(settings.keyboard.up) or gamepadAxes.y == -1 then
        beholder.trigger('INPUT_DIRECTION', 'up')
    elseif love.keyboard.isDown(settings.keyboard.down) or gamepadAxes.y == 1 then
        beholder.trigger('INPUT_DIRECTION', 'down')
    elseif love.keyboard.isDown(settings.keyboard.left) or gamepadAxes.x == -1 then
        beholder.trigger('INPUT_DIRECTION', 'left')
    elseif love.keyboard.isDown(settings.keyboard.right) or gamepadAxes.x == 1 then
        beholder.trigger('INPUT_DIRECTION', 'right')
    end

    self:update(dt)
end

--- Base draw callback.
-- Shared draws for all Game states
function Game:baseDraw()
    self:draw()
end

--- Base key pressed callback.
-- Shared key presses for all Game states
-- @tparam KeyConstant key Love 2D KeyConstant
-- @tparam Scancode code Love 2D Scancode
function Game:baseKeypressed(key, code)
    if key == settings.keyboard.confirm then
        beholder.trigger('INPUT_BUTTON', 'confirm')
    elseif key == settings.keyboard.cancel then
        beholder.trigger('INPUT_BUTTON', 'cancel')
    end

    self:keypressed(key, code)
end

--- Base joystick realesed callback.
-- Shared joystick input for all Game states
-- @tparam Joystick joystick Love 2D joystick instance
-- @tparam number button Button number
function Game:baseJoystickreleased(joystick, button)
    if button == settings.gamepad.confirm then
        beholder.trigger('INPUT_BUTTON', 'confirm')
    elseif button == settings.gamepad.cancel then
        beholder.trigger('INPUT_BUTTON', 'cancel')
    end

    self:joystickreleased(joystick, button)
end

function Game:update(dt)
end

function Game:draw()
end

function Game:keypressed(key, code)
end

function Game:joystickreleased(joystick, button)
end

function Game:drawOverlay(x, y)
--    print(self.overlay.alpha)
    if self.overlay.alpha > 0 then
        love.graphics.setColor(settings.colours.black[1], settings.colours.black[2], settings.colours.black[3], self.overlay.alpha)
        love.graphics.rectangle('fill', x, y, screenWidth * 2, screenHeight * 2)
        love.graphics.setColor(settings.colours.reset)
    end
end

function Game:fadeIn()
    Timer.tween(1, self.overlay, { alpha = 0 }, 'in-quart', function()
        beholder.trigger('TOGGLE_PLAYER_CONTROL', true)
    end)
end

function Game:fadeOut(callback)
    beholder.trigger('TOGGLE_PLAYER_CONTROL', false)
    Timer.tween(1, self.overlay, { alpha = 1 }, 'out-quart', callback)
end
