{ ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-e14";

  home-manager.users.tofu.imports = [ ./works.nix ];
}
