{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pamixer
    brightnessctl
    nwg-displays
    wl-mirror
    xwayland-satellite
  ];

  xdg.configFile = {
    "niri/config.d".source = ../../../config/niri/config.d;
    "niri/config.kdl".source = ../../../config/niri/config.kdl;
  };

  imports = [
    ./alacritty.nix
    ./fcitx5.nix
    ./firefox.nix
    ./mpv.nix
    ./nautilus.nix
    ./noctalia.nix
    ./swayimg.nix
  ];
}
