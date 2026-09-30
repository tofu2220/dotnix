{
  programs.auto-cpufreq = {
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

        enable_thresholds = true;
        start_threshold = 70;
        stop_threshold = 80;
      };
    };
  };
}
