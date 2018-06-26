require 'src.entities.entity'

Person = class('entities.Person', Entity)

function Person:initialize(init)
    Entity.initialize(self, init)
end

