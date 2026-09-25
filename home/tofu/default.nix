{ ... }:

{
  imports = [
    ./cli
    ./desktop
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.username = "tofu";
  home.homeDirectory = "/home/tofu";
  home.stateVersion = "26.05";
}
