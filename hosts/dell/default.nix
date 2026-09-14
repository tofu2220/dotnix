{ pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-dell";

  environment.systemPackages = [ pkgs.librewolf ];
}
