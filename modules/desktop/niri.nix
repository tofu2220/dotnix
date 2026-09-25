{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    useNautilus = true;
  };

  services.blueman.enable = true;
  security.soteria.enable = true;
}
