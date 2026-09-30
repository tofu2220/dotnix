{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix language tooling.
    nixd
    nixfmt

    # Nodejs
    nodejs # For zed less bloat

    # Search and data tools.
    ripgrep
    jq

    # System information and monitoring.
    lm_sensors
    microfetch
    htop
    upower

    # Networking and DNS tools
    dnsutils
    openssl
    tcpdump

    # AI coding assistant.
    opencode
  ];
}
