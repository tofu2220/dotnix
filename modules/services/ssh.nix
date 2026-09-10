{ ... }:

{
  # SSH client: gửi khả năng true-color của terminal hiện tại.
  programs.ssh.extraConfig = ''
    Host *
      SendEnv COLORTERM
  '';

  # SSH server: chấp nhận biến đó trong phiên SSH.
  services.openssh = {
    enable = true;
    openFirewall = true;

    settings.AcceptEnv = [ "COLORTERM" ];
  };
}
