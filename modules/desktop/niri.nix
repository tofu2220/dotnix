{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    useNautilus = true;
  };

  security.soteria.enable = true;
}
