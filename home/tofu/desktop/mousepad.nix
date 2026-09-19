{ pkgs, ... }:

{
  home.packages = [
    pkgs.mousepad
  ];

  xdg.configFile."Mousepad/settings.conf" = {
    force = true;

    text = ''
      [org/xfce/mousepad/preferences/view]
      word-wrap=true
      show-line-numbers=true
      color-scheme='kate'

      [org/xfce/mousepad/preferences/window]
      menubar-visible=false
    '';
  };
}
