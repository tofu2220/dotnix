{ ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
    ./mic-led.nix
  ];

  networking.hostName = "nixos-t14";
}
