{ pkgs, ... }:

{
  home.packages = [
    pkgs.unstable.brave-origin
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "text/html" = "brave-origin.desktop";
      "x-scheme-handler/http" = "brave-origin.desktop";
      "x-scheme-handler/https" = "brave-origin.desktop";
    };
  };
}
