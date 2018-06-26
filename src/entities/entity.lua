Entity = class('entities.Entity')

function Entity:initialize(init)
    self.name = init.name
    self.x = init.x
    self.y = init.y
    self.w = init.width
    self.h = init.height
end

function Entity:getPosition()
    return Vector(self.x, self.y)
end

function Entity:setPosition(position)
    self.x, self.y = position.x, position.y
end

function Entity:getRect()
    return self.x, self.y, self.w, self.h
end

function Entity:addToWorld(world)
    world:add(self, self:getRect())
end
