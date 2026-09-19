{
  imports = [
    ./appearance.nix
    ./apps.nix
    ./brave.nix
    ./fcitx5.nix
    ./mousepad.nix
    ./mpv.nix
    ./sway.nix
    ./thunar.nix
    ./zed.nix

    # Optional declarative MIME defaults; intentionally disabled to avoid overriding user/app preferences.
    # ./mime.nix
  ];
}
