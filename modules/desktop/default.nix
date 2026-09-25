{ ... }:

{
  imports = [
    ./login.nix
    ./niri.nix
    ./nautilus.nix
  ];

  services.gnome.gnome-keyring.enable = true;
}
