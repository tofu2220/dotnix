{
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;

      settings = {
        # Show Compact mode in Customize Toolbar
        "browser.compactmode.show" = true;

        # 0 = Normal, 1 = Compact, 2 = Touch
        "browser.uidensity" = 1;

        # Disable the "Support Firefox" checkbox in Firefox Home
        "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
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
          ];
        };

      Homepage = {
        StartPage = "previous-session";
      };

      FirefoxHome = {
        SponsoredTopSites = false;
        SponsoredStories = false;
      };

      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
      };

      OfferToSaveLogins = false;
      AutofillCreditCardEnabled = false;
      AutofillAddressEnabled = false;

      AIControls = {
        Default = {
          Value = "blocked";
        };
      };

      Permissions = {
        Location = {
          BlockNewRequests = true;
        };

        Notifications = {
          BlockNewRequests = true;
        };
      };

      DisableTelemetry = true;
      DisableRemoteImprovements = true;
    };
  };
}
