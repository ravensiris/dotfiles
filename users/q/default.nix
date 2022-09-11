{ self, lib, pkgs, inputs, ... }:
let firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
in {

  age.secrets.qPassword.file = "${self}/secrets/users/q.age";
  users.users.q = {
    passwordFile = "/run/agenix/qPassword";
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" ];
  };

  home-manager.users.q = { profiles, ... }: {
    imports = [ profiles.doom-emacs profiles.wm.i3 ];

    programs.direnv = {
      enable = true;
      config = {
        whitelist = {
          prefix = [
            "/media/Steiner/Projects"
            "/media/Steiner/flake"
          ];
        };
      };
    };

    services.emacs = {
      enable = true;
      defaultEditor = true;
    };

    programs.git = {
      enable = true;
      userEmail = "maksymilian.jodlowski@gmail.com";
      userName = "Maksymilian Jodłowski";
    };

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "VictorMono" "FiraCode" ]; })
      font-awesome
      pinentry-gnome
      brave
      musikcube
      imv
      p7zip
    ];

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };

    programs.mpv.enable = true;

    home.persistence."/nix/persist/home/q" = {
      files = [
        ".ssh/id_rsa"
        ".ssh/id_rsa.pub"
      ];
      directories = [
        ".gnupg"
        ".password-store"
        ".mozilla"
        ".config/BraveSoftware/Brave-Browser"
        ".config/musikcube"
      ];
      allowOther = true;
    };

    # programs.fish = {
    #   enable = true;
    #   plugins = with pkgs.fishPlugins; [
    #     {
    #       name = "pure";
    #       src = pure.src;
    #     }
    #   ];
    # };
    programs.kitty = {
      enable = true;
      font = {
        name = "VictorMono NerdFont";
        size = 18;
      };
      settings = {
        # shell = "${pkgs.fish}/bin/fish";
        confirm_os_window_close = 0;
      };
      theme = "Dracula";
    };

    programs.firefox = {
      enable = true;
      # package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      #   # forceWayland = true;
      #   extraPolicies = { ExtensionSettings = { }; };
      # };
      extensions = with firefox-addons; [
        ublock-origin
        bypass-paywalls-clean
        clearurls
        consent-o-matic
        i-dont-care-about-cookies
        libredirect
        localcdn
        octolinker
        polish-dictionary
        protondb-for-steam
        return-youtube-dislikes
        rust-search-extension
        sponsorblock
        violentmonkey
      ];
      profiles.default = {
        id = 0;
        name = "Default";
      };
    };
  };
}
