{ self, lib, pkgs, inputs, config, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  brave = pkgs.brave.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/brave

      makeWrapper $BINARYWRAPPER $out/bin/brave \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    '';
  });
  insomnia = pkgs.symlinkJoin {
    name = "${pkgs.lib.getName pkgs.insomnia}-wrapper";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = [ pkgs.gtk3 ];
    paths = [ pkgs.insomnia ];
    postBuild = ''
      wrapProgram "$out"/bin/insomnia \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    '';
  };
in
{

  age.secrets.qPassword.file = "${self}/secrets/users/q.age";
  age.secrets.google_api_token.file = "${self}/secrets/tokens/google_api_token.age";
  age.secrets.lastfm_token.file = "${self}/secrets/tokens/lastfm_token.age";

  users.users.q = {
    passwordFile = "/run/agenix/qPassword";
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" "adbusers" "input" ];
  };

  home-manager.users.q = { profiles, ... }: {
    imports = [
      profiles.neovim
    ];

    home.stateVersion = "22.11";

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

    # services.emacs = {
    #   enable = true;
    #   defaultEditor = true;
    # };

    programs.git = {
      enable = true;
      userEmail = "maksymilian.jodlowski@gmail.com";
      userName = "Maksymilian Jodłowski";
    };

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "VictorMono" "FiraCode" ]; })
      font-awesome
      pinentry-gnome
      musikcube
      imv
      p7zip
      anime4k
      yuzu
      (texlive.combine { inherit (texlive) scheme-full xetex fontspec; })
      sonixd
      pubs
      fd
      libreoffice
      khinsider
      emmet_ls
      emacs-pgtk
    ] ++ [ brave insomnia ];

    programs.beets = {
      enable = true;
      package = (pkgs.beets.override { });
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
            "lastfm"
            "coverart"
            "itunes"
            "amazon"
            "albumart"
            "google"
          ];

          minwidth = 800;
          enforce_ratio = "0.5%";

          # readFile not perfect
          google_key = lib.removeSuffix "\n" (builtins.readFile config.age.secrets.google_api_token.path);
          lastfm_key = lib.removeSuffix "\n" (builtins.readFile config.age.secrets.lastfm_token.path);
        };
        badfiles = {
          check_on_import = true;
          commands = {
            flac = "${pkgs.flac}/bin/flac --silent --test";
            mp3 = "${pkgs.mp3val}/bin/mp3val -si";
          };
        };
        plugins = lib.concatStringsSep " " [ "embedart" "fetchart" "badfiles" "fish" "duplicates" ];
      };
    };

    services.easyeffects = {
      enable = true;
    };

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
      # $XDG_DATA_HOME broke after update
      # TODO: Make a real fix instead of this temporary path
      settings = { PASSWORD_STORE_DIR = "/home/q/.password-store"; };
    };

    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        autoload
      ];
      bindings = {
        "CTRL+1" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
        "CTRL+2" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
        "CTRL+3" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
        "CTRL+4" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
        "CTRL+5" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
        "CTRL+6" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
        "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
      };
    };

    home.persistence."/nix/persist/home/q" = {
      files = [
        ".ssh/id_rsa"
        ".ssh/id_rsa.pub"
        ".local/share/nix/trusted-settings.json"
        ".local/share/beets/musiclibrary.db"
        ".config/fish/completions/beet.fish"
        ".local/share/fish/fish_history"
      ];
      directories = [
        ".gnupg"
        ".password-store"
        ".mozilla"
        ".config/BraveSoftware/Brave-Browser"
        ".config/musikcube"
        ".config/Sonixd"
        ".local/share/yuzu"
        ".config/easyeffects"
      ];
      allowOther = true;
    };

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

    home.file.".config/fish/completions/pass.fish".source = ./fish/completions/pass.fish;

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
        libredirect
        localcdn
        octolinker
        polish-dictionary
        protondb-for-steam
        return-youtube-dislikes
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
