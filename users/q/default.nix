{ self, lib, pkgs, inputs, ... }:
let firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
in {

  age.secrets.qPassword.file = "${self}/secrets/users/q.age";
  users.users.q = {
    passwordFile = "/run/agenix/qPassword";
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" "adbusers" "input" ];
  };

  home-manager.users.q = { profiles, ... }: {
    imports = [ profiles.doom-emacs profiles.wm.i3 ];

    home.file.".icons/default".source = "${pkgs.numix-cursor-theme}/share/icons/Numix-Cursor";

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
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
      anime4k
      yuzu
      (texlive.combine { inherit (texlive) scheme-full xetex fontspec; })
      sonixd
    ];

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
      ];
      directories = [
        ".gnupg"
        ".password-store"
        ".mozilla"
        ".config/BraveSoftware/Brave-Browser"
        ".config/musikcube"
        ".config/Sonixd"
        ".local/share/yuzu"
      ];
      allowOther = true;
    };

    programs.fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [
        {
          name = "pure";
          src = pure.src;
        }
      ];
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
