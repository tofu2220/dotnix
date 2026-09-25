{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
    glycin-thumbnailer
    ffmpegthumbnailer
    papers
  ];

  programs.dconf.enable = true;
  services.gvfs.enable = true;
}
