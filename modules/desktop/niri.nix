{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    useNautilus = true;
  };

  security.soteria.enable = false;
  # NixOS's programs.wayland session module registers this PAM service by default.
  security.pam.services.swaylock.enable = false;
}
