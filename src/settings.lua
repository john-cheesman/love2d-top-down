local M = {
    colours = {
        black = utility.convertColours({ 20, 12, 28 }),
        white = utility.convertColours({ 222, 238, 214 }),
        blue = utility.convertColours({ 89, 125, 206 }),
        transparent = utility.convertColours({ 255, 255, 255, 200 }),
        reset = utility.convertColours({ 255, 255, 255, 255 })
    },
    gamepad = {
        confirm = 1,
        cancel = 2,
        up = 0,
        down = 0,
        left = 0,
        right = 0
    },
    keyboard = {
        up = 'up',
        down = 'down',
        left = 'left',
        right = 'right',
        confirm = 'z',
        cancel = 'x'
    }
}

return M
