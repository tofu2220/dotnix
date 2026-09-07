{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix language tooling.
    nixd
    nixfmt

    # Search and data tools.
    ripgrep
    jq

    # System information and monitoring.
    microfetch
    htop

    # AI coding assistant.
    unstable.codex
  ];
}
