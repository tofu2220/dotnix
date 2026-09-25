{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # iPhone / iOS USB support
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice
  ];

  hardware.bluetooth.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;
}
