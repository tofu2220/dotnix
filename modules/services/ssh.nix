{ ... }:

{
  # SSH client: send the current terminal's true-color capability.
  programs.ssh.extraConfig = ''
    Host *
      SendEnv COLORTERM
  '';

  # SSH server: accept this variable in SSH sessions.
  services.openssh = {
    enable = true;
    openFirewall = true;

    settings.AcceptEnv = [ "COLORTERM" ];
  };
}
