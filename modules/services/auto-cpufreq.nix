{
  nixpkgs.overlays = [
    (final: _prev: {
      auto-cpufreq = final.unstable.auto-cpufreq;
    })
  ];

  services.auto-cpufreq = {
    enable = true;

    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
        platform_profile = "balanced";
      };

      battery = {
        governor = "powersave";
        turbo = "never";
        platform_profile = "low-power";
        enforce_platform_profile = true;
        scaling_max_freq = 2000000;
      };
    };
  };
}
