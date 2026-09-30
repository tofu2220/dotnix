{ ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "VSF-PF64LR0C-L";
  # security.pki.certificateFiles = [
  #   ./certs/company-ca.crt
  # ]; # Placeholder, wait for ca cert

  home-manager.users.tofu.imports = [ ./works.nix ];
}
