--- World game state.
-- @module world

require 'src.factory'

local World = Game:addState('World')

--- Get camera target.
-- Calculate initial camera position.
-- @tparam Game self Game instance
-- @treturn Vector Camera target vector
local function getCameraTarget(self)
    local x, y, mapWidth, mapHeight, halfScreenWidth, halfScreenHeight, playerPos

    mapWidth = self.map.width * self.map.tilewidth
    mapHeight = self.map.height * self.map.tileheight
    halfScreenWidth = love.graphics.getWidth() / 2
    halfScreenHeight = love.graphics.getHeight() / 2
    playerPos = self.player:getPosition()

    if playerPos.x < halfScreenWidth then
        x = halfScreenWidth
    elseif playerPos.x > mapWidth - halfScreenWidth then
        x = mapWidth - halfScreenWidth
    else
        x = playerPos.x
    end

    if playerPos.y < halfScreenHeight then
        y = halfScreenHeight
    elseif playerPos.y > mapHeight - halfScreenHeight then
        y = mapHeight - halfScreenHeight
    else
        y = playerPos.y
    end

    return Vector(x, y)
end

--- Entered state callback.
-- Setup observer for map loading, initialise camera and load map.
-- @tparam string map Name of the map to load
function World:enteredState(map)
    self.loadMapObserver = beholder.observe('LOAD_MAP', function(map, playerPosition)
        self:fadeOut(function() self:loadMap(map, playerPosition) end)
    end)

    self.camera = camera(screenWidth / 2, screenHeight / 2)
    self:loadMap(map)
end

--- Draw callback.
-- Draw the map, player and overlay.
function World:draw()
    local tx = math.floor(self.camera.x - screenWidth / 2)
    local ty = math.floor(self.camera.y - screenHeight / 2)

    self.map:draw(-tx, -ty)

    self.camera:attach()
        self.player:draw()
        self:drawOverlay(tx, ty)
    self.camera:detach()
end

--- Update callback.
-- Update the map, player and camera.
-- @tparam number dt Time delta
function World:update(dt)
    local cameraDelta = (self.player:getPosition() - Vector(self.camera:position())) / 2

    self.map:update(dt)
    self.player:update(dt, self.world)

    cameraDelta.x = self.camera.x + cameraDelta.x > 256 and cameraDelta.x or 0
    cameraDelta.x = self.camera.x + cameraDelta.x < (self.map.width * self.map.tilewidth) - 256 and cameraDelta.x or 0
    cameraDelta.y = self.camera.y + cameraDelta.y > 224 and cameraDelta.y or 0
    cameraDelta.y = self.camera.y + cameraDelta.y < (self.map.height * self.map.tileheight) - 224 and cameraDelta.y or 0

    self.camera:move(cameraDelta.x, cameraDelta.y)
end

--- Load map.
-- Load a different map, set player position and fade in.
-- @tparam string map Name of the map to load
-- @tparam Vector playerPosition Player position vector
function World:loadMap(map, playerPosition)
    local mapPlayerPosition, cameraTarget

    self.world = bump.newWorld(32)
    self.map = sti('assets/maps/' .. map .. '.lua', { 'bump' })
    self.map:bump_init(self.world)
    self.entityLayer = self.map:addCustomLayer('entityLayer', 3)
    self.entityLayer.entities, mapPlayerPosition = Factory.createObjects(self.map.layers.entities.objects, self.world)
    self.player:setPosition(playerPosition ~= nil and playerPosition or mapPlayerPosition)
    self.player:addToWorld(self.world)
    cameraTarget = getCameraTarget(self)
    self.camera:lookAt(cameraTarget.x, cameraTarget.y)
    self:fadeIn()
end
