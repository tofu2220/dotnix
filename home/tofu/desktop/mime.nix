{ ... }:

let
  apps = {
    fileManager = "thunar.desktop";
  };
in
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "inode/directory" = apps.fileManager;
    };
  };
}
