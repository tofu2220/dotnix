{ ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  home-manager.users.tofu.imports = [ ./whisper.nix ];

  networking.hostName = "nixos-dell";
}
