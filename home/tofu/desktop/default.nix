{
  imports = [
    ./appearance.nix
    ./apps.nix
    ./fcitx5.nix
    ./mpv.nix
    ./sway.nix
    ./swayimg.nix
    ./thunar.nix
    ./zed.nix

    # Optional declarative MIME defaults; intentionally disabled to avoid overriding user/app preferences.
    # ./mime.nix
  ];
}
