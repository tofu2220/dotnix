{ ... }:

{
  imports = [
    ../modules/core
    ../modules/desktop
    ../modules/gaming
    ../modules/services
    ../profiles/tofu.nix
  ];

  system.stateVersion = "26.05";
}
