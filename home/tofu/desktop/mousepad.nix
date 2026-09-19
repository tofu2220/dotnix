{ pkgs, ... }:

{
  home.packages = [
    pkgs.mousepad
  ];

  dconf.settings = {
    "org/xfce/mousepad/preferences/view" = {
      "word-wrap" = true;
    };

    "org/xfce/mousepad/preferences/window" = {
      "menubar-visible" = false;
    };
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplicationPackages = [
      pkgs.mousepad
    ];
  };
}
