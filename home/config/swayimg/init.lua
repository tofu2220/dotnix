-- General
swayimg.mode = "viewer"
swayimg.decoration = true
swayimg.overlay = false
swayimg.set_window_size(960, 540)

-- Viewer
swayimg.viewer.set_window_background(0xff2c2c2e)
swayimg.viewer.default_scale = "fit"
swayimg.viewer.loop = true
swayimg.viewer.preload = 1
swayimg.viewer.drag_button = "MouseLeft"

-- Gallery
swayimg.gallery.thumb_size = 200
swayimg.gallery.aspect = "fill"
swayimg.gallery.pstore = true

-- Image list
swayimg.imagelist.order = "alpha"
swayimg.imagelist.adjacent = true
swayimg.imagelist.fsmon = true

-- Info layer
swayimg.text.visible = true
swayimg.text.timeout = 5

local function exit()
  swayimg.exit()
end

local function toggle_fullscreen()
  swayimg.fullscreen = not swayimg.fullscreen
end

local function zoom(factor, mouse)
  local scale = swayimg.viewer.scale * factor

  if mouse then
    local pos = swayimg.get_mouse_pos()
    swayimg.viewer.set_abs_scale(scale, pos.x, pos.y)
  else
    swayimg.viewer.set_abs_scale(scale)
  end
end

-- Viewer bindings
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

swayimg.viewer.on_key("f", toggle_fullscreen)
swayimg.viewer.on_key("s", function() swayimg.mode = "slideshow" end)
swayimg.viewer.on_key("Return", function() swayimg.mode = "gallery" end)
swayimg.viewer.on_key("[", function() swayimg.viewer.rotate(270) end)
swayimg.viewer.on_key("]", function() swayimg.viewer.rotate(90) end)
swayimg.viewer.on_key("Escape", exit)
swayimg.viewer.on_key("q", exit)

-- Gallery bindings
swayimg.gallery.on_key("left", function() swayimg.gallery.select("left") end)
swayimg.gallery.on_key("right", function() swayimg.gallery.select("right") end)
swayimg.gallery.on_key("up", function() swayimg.gallery.select("up") end)
swayimg.gallery.on_key("down", function() swayimg.gallery.select("down") end)

swayimg.gallery.on_key("Return", function() swayimg.mode = "viewer" end)
swayimg.gallery.on_key("s", function() swayimg.mode = "slideshow" end)
swayimg.gallery.on_key("f", toggle_fullscreen)
swayimg.gallery.on_key("Escape", exit)
swayimg.gallery.on_key("q", exit)
swayimg.gallery.on_mouse("MouseLeft", function() swayimg.mode = "viewer" end)

-- Slideshow bindings
swayimg.slideshow.on_key("space", function()
  swayimg.slideshow.animation = not swayimg.slideshow.animation
end)
swayimg.slideshow.on_key("Return", function() swayimg.mode = "viewer" end)
swayimg.slideshow.on_key("Escape", exit)
swayimg.slideshow.on_key("q", exit)
