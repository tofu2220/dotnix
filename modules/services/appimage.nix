# modules/services/appimage.nix
{ ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
