{
  programs.firefox = {
    enable = true;

    profiles.default = {
      settings = {
        "layout.css.prefers-color-scheme.content-override" = 1; # Light

        # Disable the "Support Firefox" checkbox in Firefox Home
        "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;

        # Disable search suggestions
        "browser.urlbar.suggest.trending" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.suggest.engines" = false;
      };
    };

    policies = {
      Extensions =
        let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in
        {
          Install = [
            (moz "ublock-origin")
            (moz "bitwarden-password-manager")
            (moz "vietnamese-dictionary")
          ];
        };

      Homepage.StartPage = "previous-session";

      SearchSuggestEnabled = false;

      FirefoxHome = {
        SponsoredTopSites = false;
        SponsoredStories = false;
      };

      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
      };

      DisableFormHistory = true;

      OfferToSaveLogins = false;
      AutofillCreditCardEnabled = false;
      AutofillAddressEnabled = false;

      AIControls.Default.Value = "blocked";

      Permissions = {
        Location.BlockNewRequests = true;
        Autoplay.Default = "block-audio-video";
        # Notifications.BlockNewRequests = true; # Maybe someday I will reconsider this
      };

      DisableTelemetry = true;
      DisableRemoteImprovements = true;
    };
  };
}
