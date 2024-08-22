{
  config,
  pkgs,
  lib,
  ...
}: let
  nixGLPath = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";
  nixGL = (import ../../users/q/nixgl_wrapper.nix {inherit pkgs;}) nixGLPath;
in {
  home.packages = with pkgs; [
    devenv
    (pkgs.nerdfonts.override {fonts = ["VictorMono"];})
    slack
    teams-for-linux
    # bitwarden-desktop
    bitwarden-cli
    graphite-cli
    wl-clipboard
    pinentry-qt
    (pass.withExtensions (ext: with ext; [pass-otp]))
    opusTools
    pavucontrol
    musikcube
    htop
    android-tools
    bruno
    scrcpy
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.input-overlay
    obs-studio-plugins.looking-glass-obs
    obs-studio-plugins.obs-pipewire-audio-capture
    v4l-utils
    android-file-transfer
    swww
    p7zip
  ];

  imports = [
    ../../users/q/neovim
    ../../users/q/git.nix
    ../../users/q/direnv.nix
    ../../users/q/fish.nix
  ];
  neovim.impermanence = false;
  fish.impermanence = false;
  programs.bash.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    extraConfig = ''
      input * xkb_layout pl
    '';
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      # terminal = "${pkgs.kitty}/bin/kitty";
      terminal = "kitty -1";
      menu = "${pkgs.fuzzel}/bin/fuzzel --show-actions";
      gaps = {
        inner = 12;
        outer = 5;
        smartGaps = true;
        smartBorders = "no_gaps";
      };
      window.titlebar = false;
      window.commands = [
        {
          command = "floating enable, resize set 512 512";
          criteria = {
            title = "imv_album_art";
          };
        }
      ];
      workspaceAutoBackAndForth = true;
      startup = [
        {
          command = "systemctl --user restart kanshi";
          always = true;
        }
        {
          command = "XDG_CONFIG_HOME=/home/q/.config ${pkgs.swaynotificationcenter}/bin/swaync";
          always = true;
        }
        {
          command = "systemctl --user restart waybar";
          always = true;
        }
        {
          command = "kdeconnect-indicator";
          always = false;
        }
        {
          command = "${pkgs.swww}/bin/swww-daemon";
          always = false;
        }
      ];
      keybindings = lib.mkOptionDefault {
        # Focus window
        "${modifier}+n" = "focus left";
        "${modifier}+e" = "focus down";
        "${modifier}+i" = "focus up";
        "${modifier}+o" = "focus right";
        # Move window
        "${modifier}+Shift+n" = "move left";
        "${modifier}+Shift+e" = "move down";
        "${modifier}+Shift+i" = "move up";
        "${modifier}+Shift+o" = "move right";
        # Workspaces
        "${modifier}+0" = "workspace number 10";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        # Mode
        "${modifier}+u" = "layout default";
        "${modifier}+v" = "splitv";
        "${modifier}+h" = "splith";

        "${modifier}+y" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";

        # Quick launch
        "${modifier}+m" = "exec emacsclient -c";

        "${modifier}+s" = "layout default";
        "${modifier}+w" = "layout default";

        "${modifier}+p" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

        "${modifier}+Mod1+n" = "move workspace to output left";
        "${modifier}+Mod1+e" = "move workspace to output down";
        "${modifier}+Mod1+i" = "move workspace to output up";
        "${modifier}+Mod1+o" = "move workspace to output right";
      };
      modes = {
        resize = {
          # colemak
          n = "resize shrink width 50px";
          e = "resize grow height 50px";
          i = "resize shrink height 50px";
          o = "resize grow width 50px";
          # arrows
          Left = "resize shrink width 50px";
          Up = "resize grow height 50px";
          Down = "resize shrink height 50px";
          Right = "resize grow width 50px";
          # Set %
          Equal = "resize set height 50ppt";
          "1" = "resize set height 10ppt";
          "2" = "resize set height 20ppt";
          "3" = "resize set height 30ppt";
          "4" = "resize set height 40ppt";
          "5" = "resize set height 50ppt";
          "6" = "resize set height 60ppt";
          "7" = "resize set height 70ppt";
          "8" = "resize set height 80ppt";
          "9" = "resize set height 90ppt";
          Escape = "mode default";
        };
      };
      fonts = {
        names = ["VictorMono Nerd Font"];
        style = "Regular";
        size = 16.0;
      };
      bars = [];
    };
  };

  programs.kitty = {
    enable = false;
    font = {
      name = "VictorMono NerdFont";
      size = 15;
    };
    settings = {
      confirm_os_window_close = 0;
    };
    extraConfig = builtins.concatStringsSep "\n" [
      "background_opacity 0.9"
      ''
        # Tokyo Night color scheme for kitty terminal emulator
        # https://github.com/davidmathers/tokyo-night-kitty-theme
        #
        # Based on Tokyo Night color theme for Visual Studio Code
        # https://github.com/enkia/tokyo-night-vscode-theme

        foreground #a9b1d6
        background #1a1b26

        # Black
        color0 #414868
        color8 #414868

        # Red
        color1 #f7768e
        color9 #f7768e

        # Green
        color2  #73daca
        color10 #73daca

        # Yellow
        color3  #e0af68
        color11 #e0af68

        # Blue
        color4  #7aa2f7
        color12 #7aa2f7

        # Magenta
        color5  #bb9af7
        color13 #bb9af7

        # Cyan
        color6  #7dcfff
        color14 #7dcfff

        # White
        color7  #c0caf5
        color15 #c0caf5

        # Cursor
        cursor #c0caf5
        cursor_text_color #1a1b26

        # Selection highlight
        selection_foreground none
        selection_background #28344a

        # The color for highlighting URLs on mouse-over
        url_color #9ece6a

        # Window borders
        active_border_color #3d59a1
        inactive_border_color #101014
        bell_border_color #e0af68

        # Tab bar
        tab_bar_style fade
        tab_fade 1
        active_tab_foreground   #3d59a1
        active_tab_background   #16161e
        active_tab_font_style   bold
        inactive_tab_foreground #787c99
        inactive_tab_background #16161e
        inactive_tab_font_style bold
        tab_bar_background #101014

        # Title bar
        macos_titlebar_color #16161e

        # Storm
        # background #24283b
        # cursor_text_color #24283b
        # active_tab_background   #1f2335
        # inactive_tab_background #1f2335
        # macos_titlebar_color #1f2335
      ''
    ];
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ../../users/q/waybar.css;
    settings = {
      sideBar = {
        layer = "top";
        position = "top";
        height = 16;
        output = [
          "LG Electronics LG SDQHD 205NTNH5W679"
          "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190"
        ];
        modules-center = ["clock"];
        modules-left = ["sway/workspaces"];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };

        clock = {
          format = "   {:%R}";
          tooltip-format = "<tt><span>{calendar}</span></tt>";
          calendar.format = {
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };
      mainBar = {
        layer = "top";
        position = "top";
        height = 16;
        output = [
          "ASUSTek COMPUTER INC ASUS VG32V 0x0000B75D"
          "ASUSTek COMPUTER INC ASUS VG32V 0x0003B55D"
          "eDP-1"
        ];
        modules-left = ["sway/workspaces" "mpris"];
        modules-center = ["clock"];
        modules-right = ["battery" "memory" "cpu" "tray"];

        battery = {
          format = "{capacity}% {icon}";
          format-icons = [" " " " " " " " " "];
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
        };

        memory = {
          interval = 30;
          format = "{}%  ";
          max-length = 10;
        };

        tray = {
          icon-size = 24;
          spacing = 8;
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };

        mpris = {
          interval = 15;
          format = "<span font_family=\"Victor Mono Nerd Font\"> </span>{album} · {title}";
        };

        cpu.format = "{usage}% ";

        clock = {
          format = "   {:%R}";
          tooltip-format = "<tt><span>{calendar}</span></tt>";
          calendar.format = {
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };
    };
  };

  services.kanshi = {
    enable = true;
    profiles = {
      desktop = {
        outputs = [
          {
            criteria = "ASUSTek COMPUTER INC ASUS VG32V 0x0000B75D";
            position = "0,1440";
          }
          {
            criteria = "LG Electronics LG SDQHD 205NTNH5W679";
            position = "2560,0";
          }
        ];
      };

      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
          {
            criteria = "*";
            status = "enable";
          }
        ];
      };

      docked = {
        exec = [
          "for workspace in $(seq 1 5); do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'ASUSTek COMPUTER INC ASUS VG32V 0x0003B55D'\"; done"
          "for workspace in $(seq 6 10); do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'LG Electronics LG SDQHD 205NTNH5W679'\"; done"
        ];
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "ASUSTek COMPUTER INC ASUS VG32V 0x0003B55D";
            position = "0,1440";
          }
          {
            criteria = "LG Electronics LG SDQHD 205NTNH5W679";
            position = "2560,0";
          }
        ];
      };

      docked_secondary = {
        exec = [
          "for workspace in $(seq 1 5); do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190'\"; done"
          "for workspace in $(seq 6 10); do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'eDP-1'\"; done"
        ];
        outputs = [
          {
            criteria = "eDP-1";
            position = "3840,960";
          }
          {
            criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190";
            position = "0,0";
          }
        ];
      };
    };
  };

  programs.home-manager.enable = true;
  home.username = "q";
  home.homeDirectory = "/home/q";
  home.stateVersion = "23.11";
}
