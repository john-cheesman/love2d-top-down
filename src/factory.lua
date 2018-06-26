--- Entity factory
-- @classmod Factory

require 'src.entities.exit'
require 'src.entities.person'

Factory = class('Factory')

--- Table of entity classes
Factory.static.entities = {
    Exit = Exit, -- Exit entity
    Person = Person -- Person entity
}

--- Create an entity instance from map object.
-- @tparam table mapObject Map object
-- @treturn table Entity instance
-- @raise Entity type %type% not found in factory.create
function Factory.static.create(mapObject)
    assert(Factory.entities[mapObject.type] ~= nil, 'Entity type ' .. mapObject.type .. ' not found in factory.create')

    local type = Factory.entities[mapObject.type]

    return type(mapObject)
end

--- Create objects and add to the world.
-- Also returns player position vector
-- @tparam {table,...} objectArray Table of map objects
-- @tparam World world Love2D World instance
-- @treturn {table,...} Table of entity instances
-- @treturn Vector Player position
function Factory.static.createObjects(objectArray, world)
    local playerPosition, entities = Vector(), {}

    for i, entity in pairs(objectArray) do
        local instance

        if entity.type == 'Player' then
            playerPosition.x = entity.x
            playerPosition.y = entity.y
        else
            instance = Factory.create(entity)
            table.insert(entities, instance)
            instance:addToWorld(world)
        end
    end

    return entities, playerPosition
end
