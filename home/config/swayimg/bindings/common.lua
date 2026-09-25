local M = {}

function M.exit()
  swayimg.exit()
end

function M.toggle_fullscreen()
  swayimg.fullscreen = not swayimg.fullscreen
end

return M
