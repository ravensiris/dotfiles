{
  lib,
  pkgs,
  ...
}: let
  swww_set_wallpapers_per_output = pkgs.writeShellScriptBin "swww_set_wallpapers_per_output" ''
    output_dirs=$(${pkgs.sway}/bin/swaymsg -r -t get_outputs | ${pkgs.jq}/bin/jq -c 'map(.make + " " + .model + " " + .serial + "[" + (.current_mode.width|tostring) + "x" + (.current_mode.height|tostring) + "]")' | ${pkgs.jq}/bin/jq -r '.[] | @base64')
    for output_dir_b64 in $output_dirs; do
      output_dir=$(echo $output_dir_b64 | base64 --decode)
      wallpaper_dir="$HOME/Pictures/Wallpapers/$output_dir"
      if [ -d "$wallpaper_dir" ]; then
          wallpaper_path=$(find "$wallpaper_dir" -type f | shuf -n 1)
          if [ "$wallpaper_path" = "" ]; then
              echo "No wallpapers found in $wallpaper_dir!"
              ${pkgs.libnotify}/bin/notify-send \
                  -u critical \
                  "Failed to set wallpaper!" \
                  "No wallpapers found in $wallpaper_dir!"
          else
              output_name=$(${pkgs.sway}/bin/swaymsg -r -t get_outputs | ${pkgs.jq}/bin/jq -c -r '.[] | select((.make + " " + .model + " " + .serial + "[" + (.current_mode.width|tostring) + "x" + (.current_mode.height|tostring) + "]") | contains("'"$output_dir"'")).name')
              echo "Setting wallpaper $wallpaper_path for $output_name"
              ${pkgs.swww}/bin/swww img -o "$output_name" "$wallpaper_path" \
              || (echo "Failed setting wallpaper during swww call(OUTPUT=$output_name, WALLPAPER_PATH=$wallpaper_path)" \
              && ${pkgs.libnotify}/bin/notify-send \
                  -u critical \
                  "Failed to set wallpaper!" \
                  "Failed during swww call!")
          fi
      else
          echo "'$wallpaper_dir' doesn't exist!"
          ${pkgs.libnotify}/bin/notify-send \
              -u critical \
              "Failed to set wallpaper!" \
              "'$wallpaper_dir' doesn't exist!"
      fi
    done
  '';
  display_album_art = pkgs.writeShellScriptBin "display_album_art" ''
       ${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl \
    | ${pkgs.imv}/bin/imv -w "imv_album_art" -c center
  '';
  lock_command = pkgs.writeShellScriptBin "lock_command" ''
    ${pkgs.swaylock-effects}/bin/swaylock \
        -i "/home/q/Pictures/Wallpapers/BOE 0x0A32 Unknown[1920x1200]/1668207169460117.jpg" \
        --daemonize \
        --ignore-empty-password \
        --show-failed-attempts \
        --effect-blur 7x5
  '';
in {
  home.packages = with pkgs; [playerctl swww] ++ [swww_set_wallpapers_per_output lock_command];

  home.pointerCursor = {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    gtk.enable = true;
    x11.enable = true;
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${lock_command}/bin/lock_command";
      }
    ];
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
          "for workspace in {1..5}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace, move workspace to 'ASUSTek COMPUTER INC ASUS VG32V 0x0000B75D'\"; done"
          "for workspace in {1..5}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'ASUSTek COMPUTER INC ASUS VG32V 0x0000B75D'\"; done"
          "for workspace in {6..10}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace, move workspace to 'LG Electronics LG SDQHD 205NTNH5W679'\"; done"
          "for workspace in {6..10}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'LG Electronics LG SDQHD 205NTNH5W679'\"; done"
        ];
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
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

      docked_secondary = {
        exec = [
          "for workspace in {1..5}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace, move workspace to 'GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190'\"; done"
          "for workspace in {1..5}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190'\"; done"
          "for workspace in {6..10}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace, move workspace to 'eDP-1'\"; done"
          "for workspace in {6..10}; do ${pkgs.sway}/bin/swaymsg \"workspace $workspace output 'eDP-1'\"; done"
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

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar.css;
    settings = {
      sideBar = {
        layer = "top";
        position = "top";
        height = 16;
        output = [
          "LG Electronics LG SDQHD 205NTNH5W679"
          "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190"
        ];
        modules-left = ["sway/workspaces"];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };
      };
      mainBar = {
        layer = "top";
        position = "top";
        height = 16;
        output = [
          "ASUSTek COMPUTER INC ASUS VG32V 0x0000B75D"
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
          on-click = "${display_album_art}/bin/display_album_art";
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
          command = "${pkgs.swww}/bin/swww init";
          always = true;
        }
        {
          command = "${swww_set_wallpapers_per_output}/bin/swww_set_wallpapers_per_output";
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
        "${modifier}+l" = "exec ${lock_command}/bin/lock_command";
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
}
