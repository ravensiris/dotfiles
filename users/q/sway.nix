{
  lib,
  pkgs,
  ...
}: let
  display_album_art = pkgs.writeShellScriptBin "display_album_art" ''
       ${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl \
    | ${pkgs.imv}/bin/imv -w "imv_album_art" -c center
  '';
in {
  home.packages = with pkgs;
    [
      cava
      playerctl
    ]
    ++ [display_album_art];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "HDMI-A-2"
        ];
        modules-left = ["sway/workspaces"];
        modules-center = ["clock"];
        modules-right = ["cpu" "mpris" "cava" "tray"];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        mpris = {
          interval = 15;
          format = "{album} · {title}";
          on-click = "${display_album_art}/bin/display_album_art";
        };

        cpu.format = "   {usage}%";

        clock = {
          format = "   {:%R}";
          tooltip-format = "<tt><span size='xx-large'>{calendar}</span></tt>";
          calendar.format = {
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };

        cava = {
          method = "pipewire";
          bars = 48;
          lower_cutoff_freq = "50";
          higher_cutoff_freq = "18000";
          bar_delimiter = 0;
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          tooltip = true;
        };
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      input * xkb_layout pl
    '';
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.fuzzel}/bin/fuzzel --show-actions";

      window.titlebar = false;
      window.commands = [
        {
          command = "floating enable, resize set 512 512";
          criteria = {
            title = "imv_album_art";
          };
        }
      ];

      output = {
        HDMI-A-2 = {
          bg = "\$(find ~/Pictures/Wallpapers/ -type f | shuf -n 1) fill";
        };
      };

      startup = [
        {
          command = "XDG_CONFIG_HOME=/home/q/.config ${pkgs.swaynotificationcenter}/bin/swaync";
          always = true;
        }
        {
          command = "systemctl --user restart waybar";
          always = true;
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
      bars = [];
      fonts = {
        names = ["VictorMono Nerd Font"];
        style = "Regular";
        size = 18.0;
      };
    };
  };
}
