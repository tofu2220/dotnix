{ pkgs, ... }:

let
  repo = "/home/tofu/Projects/dotnix";
  git = "${pkgs.git}/bin/git";
in
{
  systemd.services.dotnix-github-sync = {
    description = "Synchronize dotnix from GitHub";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "tofu";
      WorkingDirectory = repo;
      ExecStart = pkgs.writeShellScript "dotnix-github-sync" ''
        set -euo pipefail

        ${git} rev-parse --is-inside-work-tree >/dev/null

        if [ -n "$(${git} status --porcelain)" ]; then
          echo "Refusing sync: local changes exist in ${repo}" >&2
          exit 1
        fi

        ${git} fetch --quiet \
          https://github.com/tofu2220/dotnix.git \
          refs/heads/master:refs/remotes/dotnix-sync/master

        ${git} merge --ff-only --no-edit refs/remotes/dotnix-sync/master
      '';
    };
  };

  systemd.timers.dotnix-github-sync = {
    description = "Check GitHub hourly for dotnix updates";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
      Unit = "dotnix-github-sync.service";
    };
  };
}
