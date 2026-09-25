local common = require("swayimg.bindings.common")

swayimg.gallery.on_key("left", function() swayimg.gallery.select("left") end)
swayimg.gallery.on_key("right", function() swayimg.gallery.select("right") end)
swayimg.gallery.on_key("up", function() swayimg.gallery.select("up") end)
swayimg.gallery.on_key("down", function() swayimg.gallery.select("down") end)

swayimg.gallery.on_key("Return", function() swayimg.mode = "viewer" end)
swayimg.gallery.on_key("s", function() swayimg.mode = "slideshow" end)
swayimg.gallery.on_key("f", common.toggle_fullscreen)
swayimg.gallery.on_key("Escape", common.exit)
swayimg.gallery.on_key("q", common.exit)
swayimg.gallery.on_mouse("MouseLeft", function() swayimg.mode = "viewer" end)
