{
  pkgs,
  impermanence,
  config,
  lib,
  ...
}: {
  users.mutableUsers = false;
  users.users.q = {
    # passwordFile = "/run/agenix/qPassword";
    password = "arstarst";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input"];
    shell = pkgs.fish;
  };

  home-manager.users.q = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      black
      ruff
      isort
      mypy
      neovim
      pinentry-gnome
      musikcube
      stylua
      lua-language-server
      ripgrep
      gnumake
      htop
    ];
    imports = [impermanence.nixosModules.home-manager.impermanence];

    xdg = {
      enable = true;
      configFile."nvim" = {
        source = ../../config/neovim;
        recursive = true;
      };

      desktopEntries = {
        firefox = {
          name = "Firefox";
          genericName = "Web Browser";
          exec = "firefox %U";
          terminal = false;
          categories = ["Application" "Network" "WebBrowser"];
          mimeType = ["text/html" "text/xml"];
          actions = {
            "Work-Profile" = {
              exec = ''${pkgs.firefox}/bin/firefox -P "Work"'';
              name = "Work Profile";
            };
          };
        };
      };
    };

    home.persistence."/nix/persist/home/q" = {
      files = [
        ".ssh/id_rsa"
        ".ssh/id_rsa.pub"
        ".ssh/id_ed25519.pub"
        ".ssh/id_ed25519"
        ".local/share/nix/trusted-settings.json"
        ".local/share/beets/musiclibrary.db"
        ".config/fish/completions/beet.fish"
        ".local/share/fish/fish_history"
      ];
      directories = [
        ".gnupg"
        ".password-store"
        ".config/BraveSoftware/Brave-Browser"
        ".config/musikcube"
        ".config/Sonixd"
        ".local/share/yuzu"
        ".config/easyeffects"
        ".mozilla"
      ];
      allowOther = true;
    };
    programs.kitty = {
      enable = true;
      font = {
        name = "VictorMono NerdFont";
        size = 18;
      };
      settings = {
        shell = "${pkgs.fish}/bin/fish";
        confirm_os_window_close = 0;
      };
      theme = "Dracula";
      extraConfig = builtins.concatStringsSep "\n" [
        "background_opacity 0.9"
      ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        whitelist = {
          prefix = [
            "/home/q/Projects"
          ];
        };
      };
    };

    programs.firefox = {
      enable = true;
      profiles.default = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
        ];
        id = 0;
        name = "Default";
      };
      profiles.personal = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
        ];
        id = 1;
        name = "Personal";
      };

      profiles.work = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
        ];
        id = 2;
        name = "Work";
      };
    };

    programs.git = {
      enable = true;
      signing = {
        signByDefault = true;
        key = null;
      };
      userEmail = "maksymilian.jodlowski@gmail.com";
      userName = "Maksymilian Jodłowski";
    };

    programs.gpg.enable = true;

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
          if [ (tput cols) -ge 40 ]; and [ (tput lines) -ge 18 ]; ${pkgs.nitch}/bin/nitch; end
        end
      '';
      plugins = with pkgs.fishPlugins; [
        {
          name = "pure";
          src = pure.src;
        }
      ];
      shellAliases = {
        "du" = "${pkgs.du-dust}/bin/dust";
        "ls" = "${pkgs.exa}/bin/exa --icons";
        "la" = "${pkgs.exa}/bin/exa --icons -la";
        "cat" = "${pkgs.bat}/bin/bat";
        "df" = "${pkgs.duf}/bin/duf";
        "ps" = "${pkgs.procs}/bin/procs";
        "curl" = "${pkgs.curlie}/bin/curlie";
        "dig" = "${pkgs.dogdns}/bin/dog";
        "cp" = "${pkgs.xcp}/bin/xcp";
      };
    };
    programs.beets = {
      enable = false;
      package = pkgs.beets.override {};
      settings = {
        directory = "~/Music";
        library = "~/.local/share/beets/musiclibrary.db";
        "import" = {
          move = false;
          copy = true;
        };
        fetchart = {
          high_resolution = true;
          sources = [
            "filesystem"
            "albumart"
            "coverart"
            "itunes"
            "amazon"
          ];

          minwidth = 800;
          enforce_ratio = "0.5%";

          # readFile not perfect
        };
        badfiles = {
          check_on_import = true;
          commands = {
            flac = "${pkgs.flac}/bin/flac --silent --test";
            mp3 = "${pkgs.mp3val}/bin/mp3val -si";
          };
        };
        plugins = lib.concatStringsSep " " ["embedart" "fetchart" "badfiles" "fish" "duplicates"];
      };
    };

    home.stateVersion = "23.05";
  };
}
