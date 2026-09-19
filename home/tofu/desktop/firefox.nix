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

      Preferences = {
        # Show search suggestions
        "browser.urlbar.suggest.searches" = {
          Value = false;
          Status = "default";
        };

        "browser.search.suggest.enabled" = {
          Value = false;
          Status = "default";
        };

        # Trending search suggestions
        "browser.urlbar.suggest.trending" = {
          Value = false;
          Status = "default";
        };

        # Show search suggestions before browsing history
        "browser.urlbar.showSearchSuggestionsFirst" = {
          Value = false;
          Status = "default";
        };

        # Address Bar: Browsing history
        "browser.urlbar.suggest.history" = {
          Value = false;
          Status = "default";
        };

        # Address Bar: Shortcuts
        "browser.urlbar.suggest.topsites" = {
          Value = false;
          Status = "default";
        };

        # Address Bar: Recent searches
        "browser.urlbar.suggest.recentsearches" = {
          Value = false;
          Status = "default";
        };

        # Address Bar: Suggest search engines to use
        "browser.urlbar.suggest.engines" = {
          Value = false;
          Status = "default";
        };
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
