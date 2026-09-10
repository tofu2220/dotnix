{ ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
    ./github-sync.nix
  ];

  networking.hostName = "nixos-dell";
}
