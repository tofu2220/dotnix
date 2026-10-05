{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      targets = [ "niri.service" ];
    };
  };

  xdg.configFile."waybar".source = ../../../config/waybar;
}
