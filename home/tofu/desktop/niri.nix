{ pkgs, ... }:

{
  home.packages = with pkgs; [
    foot
    fuzzel
    mako
    libnotify
    unstable.swayimg
    waybar
    wlogout

    pamixer
    brightnessctl
    nwg-displays
    xwayland-satellite
    swaylock
    swayidle
  ];

  xdg.configFile = {
    "foot".source = ../../config/foot;
    "fuzzel".source = ../../config/fuzzel;
    "mako".source = ../../config/mako;
    "niri/config.kdl".source = ../../config/niri/config.kdl;
    "niri/config.d".source = ../../config/niri/config.d;
    "swayimg".source = ../../config/swayimg;
    "waybar".source = ../../config/waybar;
    "wlogout".source = ../../config/wlogout;
  };
}
