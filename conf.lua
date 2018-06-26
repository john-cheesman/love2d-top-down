function love.conf(t)
    t.identity = 'love2d-top-down'
    t.version = '11.1'

    -- Window
    t.window.title = 'Love 2D Top Down'
    t.window.width = 512
    t.window.height = 448

    -- Modules
    t.modules.physics = false
end
