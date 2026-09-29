{ pkgs, ... }:

{
  programs.swayimg = {
    enable = true;
    package = pkgs.unstable.swayimg;
  };

  xdg.configFile."swayimg".source = ../../../config/swayimg;
}
