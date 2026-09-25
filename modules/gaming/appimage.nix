# For game emulators like duckstation
{ ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
