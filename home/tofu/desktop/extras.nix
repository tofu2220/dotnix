{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Archive
    file-roller

    # BitTorrent
    unstable.qbittorrent

    # Clipboard
    wl-clipboard

    # Text Editor
    gnome-text-editor
  ];
}
