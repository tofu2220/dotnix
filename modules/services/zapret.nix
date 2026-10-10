# Change to zapret2 when I switch to nixos 26.11
{
  services.zapret = {
    enable = true;

    params = [
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
    ];
  };
}
