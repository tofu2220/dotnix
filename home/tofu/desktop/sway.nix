{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    pamixer
    i3status-rust
    nwg-displays # For presentation with many external monitor
    autotiling-rs

    # Image viewer
    unstable.swayimg

    # Screenshot
    satty
    slurp
    wl-clipboard

    # Notification
    mako
    libnotify
  ];

  xdg.configFile = {
    "foot".source = ../../config/foot;
    "fuzzel".source = ../../config/fuzzel;
    "i3status-rust".source = ../../config/i3status-rust;
    "mako".source = ../../config/mako;
    "satty".source = ../../config/satty;
    "swayimg".source = ../../config/swayimg;
    "sway/config.d".source = ../../config/sway/config.d;
    "sway/config".source = ../../config/sway/config;
  };
}
