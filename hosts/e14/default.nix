{ ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-e14";
  # security.pki.certificateFiles = [
  #   ./certs/company-ca.crt
  # ]; # Placeholder, wait for ca cert

  home-manager.users.tofu.imports = [ ./works.nix ];
}
