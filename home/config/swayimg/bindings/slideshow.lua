local common = require("swayimg.bindings.common")

swayimg.slideshow.on_key("space", function()
  swayimg.slideshow.animation = not swayimg.slideshow.animation
end)
swayimg.slideshow.on_key("Return", function() swayimg.mode = "viewer" end)
swayimg.slideshow.on_key("Escape", common.exit)
swayimg.slideshow.on_key("q", common.exit)
