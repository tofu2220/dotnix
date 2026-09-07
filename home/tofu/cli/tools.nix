{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix language tooling.
    nil
    nixfmt

    # C/C++ language tooling (includes clangd).
    clang-tools

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
