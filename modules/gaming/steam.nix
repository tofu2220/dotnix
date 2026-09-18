{ pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];

  programs.steam = {
    enable = true;

    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
