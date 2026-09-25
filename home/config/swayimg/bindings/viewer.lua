local common = require("swayimg.bindings.common")

local function zoom(factor, mouse)
  local scale = swayimg.viewer.scale * factor

  if mouse then
    local pos = swayimg.get_mouse_pos()
    swayimg.viewer.set_abs_scale(scale, pos.x, pos.y)
  else
    swayimg.viewer.set_abs_scale(scale)
  end
end

swayimg.viewer.on_key("left", function() swayimg.viewer.open("prev") end)
swayimg.viewer.on_key("right", function() swayimg.viewer.open("next") end)
swayimg.viewer.on_key("space", function() swayimg.viewer.open("next") end)
swayimg.viewer.on_key("prior", function() swayimg.viewer.open("prev") end)
swayimg.viewer.on_key("next", function() swayimg.viewer.open("next") end)

swayimg.viewer.on_key("equal", function() zoom(1.1) end)
swayimg.viewer.on_key("plus", function() zoom(1.1) end)
swayimg.viewer.on_key("minus", function() zoom(0.9) end)
swayimg.viewer.on_key("backspace", function()
  swayimg.viewer.set_fix_scale("optimal")
end)

swayimg.viewer.on_mouse("Ctrl+ScrollUp", function() zoom(1.1, true) end)
swayimg.viewer.on_mouse("Ctrl+ScrollDown", function() zoom(0.9, true) end)

swayimg.viewer.on_key("f", common.toggle_fullscreen)
swayimg.viewer.on_key("s", function() swayimg.mode = "slideshow" end)
swayimg.viewer.on_key("Return", function() swayimg.mode = "gallery" end)
swayimg.viewer.on_key("[", function() swayimg.viewer.rotate(270) end)
swayimg.viewer.on_key("]", function() swayimg.viewer.rotate(90) end)
swayimg.viewer.on_key("Escape", common.exit)
swayimg.viewer.on_key("q", common.exit)
