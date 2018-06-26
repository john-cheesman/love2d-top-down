require 'src.entities.exit'

Player = class('entities.Player', Person)

local function initAnimations(image)
    local animations = {}
    local grid = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())

    animations.up = anim8.newAnimation(grid('1-4', 4), 0.15)
    animations.down = anim8.newAnimation(grid('1-4', 1), 0.15)
    animations.left = anim8.newAnimation(grid('1-4', 2), 0.15)
    animations.right = anim8.newAnimation(grid('1-4', 3), 0.15)
    animations.upIdle = anim8.newAnimation(grid(1, 4), 0.15)
    animations.downIdle = anim8.newAnimation(grid(1, 1), 0.15)
    animations.leftIdle = anim8.newAnimation(grid(1, 2), 0.15)
    animations.rightIdle = anim8.newAnimation(grid(1, 3), 0.15)

    return animations
end

local function playerFilter(item, other)
    if other.isInstanceOf ~= nil and other:isInstanceOf(Exit) then
        return 'cross'
    end

    return 'slide'
end

local function handleCollision(self, collision, x, y)
    local other = collision.other

    self.touching = other

    if other.isInstanceOf ~= nil and other:isInstanceOf(Exit) then
        other:use()
    end
end

local function toggleControl(self, enable)
    if enable then
        beholder.group(self.inputObserverGroup, function()
            beholder.observe('INPUT_DIRECTION', function(dir) self:input(dir) end)
            beholder.observe('INPUT_BUTTON', function(btn) self:input(btn) end)
        end)
    else
        beholder.stopObserving(self.inputObserverGroup)
    end
end

function Player:initialize(init)
    assert(init.image ~= nil, 'Player expects an image parameter')
    
    Person.initialize(self, init)

    self.speed = 100
    self.inputDirection = Vector()
    self.inputObserverGroup = {}
    self.toggleControlObserver = beholder.observe('TOGGLE_PLAYER_CONTROL', function(enable) toggleControl(self, enable) end)
    self.image = init.image
    self.animations = initAnimations(self.image)
    self.direction = 'down'
    self.animation = self.animations.downIdle
end

function Player:update(dt, world)
    local delta = self.inputDirection * self.speed * dt

    if delta ~= Vector() then
        self.touching = nil

        local targetPosition = self:getPosition() + delta
        local actualX, actualY, cols, len = world:move(self, targetPosition.x, targetPosition.y, playerFilter)

        for i = 1, len do
            handleCollision(self, cols[i], actualX, actualY)
        end

        self:setPosition(Vector(actualX, actualY))

        self.inputDirection = Vector()

        self:switchAnimation(self.direction)
    else
        self:switchAnimation(self.direction .. 'Idle')
    end

    self.animation:update(dt)
end

function Player:draw()
    self.animation:draw(self.image, self.x - 3, self.y - 16)
    love.graphics.rectangle('line', self.x, self.y, 26, 16)
end

function Player:input(type)
    if type == 'up' then
        self.inputDirection.y = -1
        self.direction = 'up'
    elseif type == 'down' then
        self.inputDirection.y = 1
        self.direction = 'down'
    elseif type == 'left' then
        self.inputDirection.x = -1
        self.direction = 'left'
    elseif type == 'right' then
        self.inputDirection.x = 1
        self.direction = 'right'
    elseif type == 'confirm' then
        if self.touching ~= nil and self.touching.interact ~= nil then
            self.touching:interact()
        end
    end
end

function Player:switchAnimation(animationName)
    if self.animation ~= self.animations[animationName] then
        self.animation = self.animations[animationName]
    end
end

