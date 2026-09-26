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
    lm_sensors
    microfetch
    htop

    # Networking and DNS tools
    dnsutils
    openssl
    tcpdump

    # AI coding assistant.
    unstable.codex
  ];
}
