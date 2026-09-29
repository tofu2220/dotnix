{ pkgs, ... }:

{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../../config/swaync/config.json);
    style = builtins.readFile ../../config/swaync/style.css;
  };

  home.packages = with pkgs; [
    foot
    fuzzel
    libnotify
    unstable.swayimg
    waybar
    wlogout

    pamixer
    brightnessctl
    nwg-displays
    wl-mirror
    xwayland-satellite
    swaylock
    swayidle
  ];

  xdg.configFile = {
    "foot".source = ../../config/foot;
    "fuzzel".source = ../../config/fuzzel;
    "niri/config.kdl".source = ../../config/niri/config.kdl;
    "niri/config.d".source = ../../config/niri/config.d;
    "swayimg".source = ../../config/swayimg;
    "waybar".source = ../../config/waybar;
    "wlogout".source = ../../config/wlogout;
  };
}
