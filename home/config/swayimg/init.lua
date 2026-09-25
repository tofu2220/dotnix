local config_home = os.getenv("XDG_CONFIG_HOME")
if not config_home or config_home == "" then
  config_home = os.getenv("HOME") .. "/.config"
end

package.path = config_home .. "/?.lua;" .. package.path

require("swayimg.settings")
require("swayimg.bindings.viewer")
require("swayimg.bindings.gallery")
require("swayimg.bindings.slideshow")
