{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    useNautilus = true;
  };

  security.soteria.enable = true;
  services.blueman = {
    enable = true;
    # withApplet = false; # Wait for newest stable version have this line
  };
  security.pam.services.swaylock = { };
}
