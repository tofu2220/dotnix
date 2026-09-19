{ pkgs, ... }:

{
  home.packages = [
    # Archive
    pkgs.file-roller

    # BitTorrent
    pkgs.unstable.qbittorrent
  ];
}
