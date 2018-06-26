require 'src.entities.entity'

Exit = class('entities.Exit', Entity)

function Exit:initialize(init)
    assert(init.properties.map ~= nil, 'Exit.new expects a map parameter')

    Entity.initialize(self, init)

    self.map = init.properties.map
    self.targetPosition = Vector(init.properties.targetX, init.properties.targetY)

    return self
end

function Exit:use()
    beholder.trigger('LOAD_MAP', self.map, self.targetPosition)

--    return self.targetPosition.x, self.targetPosition.y
end
