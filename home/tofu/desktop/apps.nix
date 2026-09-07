{ pkgs, ... }:

{
  home.packages = [
    # Browser
    pkgs.unstable.brave-origin

    # Editor
    pkgs.mousepad

    # Archive
    pkgs.file-roller
  ];
}
