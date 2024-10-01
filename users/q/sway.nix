{
  lib,
  pkgs,
  ...
}: let
  gigabyte_4k_monitor = "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190";
  lg_dualup_monitor = "LG Electronics LG SDQHD 205NTNH5W679";
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
  mpvpaper_set_for_output = pkgs.writeShellScriptBin "mpvpaper_set_for_output" ''
    shopt -s globstar failglob
    if [[ $# -eq 0 ]] ; then
        echo 'partial monitor name required'
        exit 0
    fi
    monitor_name="$1"
    filtered_monitors=$(${pkgs.sway}/bin/swaymsg -r -t get_outputs | ${pkgs.jq}/bin/jq -rc '[.[] | select((.make + " " + .model + " " + .serial + "[" + (.current_mode.width|tostring) + "x" + (.current_mode.height|tostring) + "]") | contains("'"$monitor_name"'"))]')
    monitor_dir_name=$(echo "$filtered_monitors" | ${pkgs.jq}/bin/jq -rc '.[0] | .make + " " + .model + " " + .serial + "[" + (.current_mode.width|tostring) + "x" + (.current_mode.height|tostring) + "]"')
    output_name=$(echo "$filtered_monitors" | ${pkgs.jq}/bin/jq -rc '.[0].name')
    mpv_vf=$(echo "$filtered_monitors" | ${pkgs.jq}/bin/jq -rc '.[0].current_mode | "scale=" + (.width|tostring) + ":" + (.height|tostring) + ":force_original_aspect_ratio=increase,crop="  + (.width|tostring) + ":" + (.height|tostring)')
    wallpaper_files=("/home/q/Pictures/Wallpapers/""$monitor_dir_name"/**/*)
    random_wallpaper_file="''${wallpaper_files[RANDOM % ''${#wallpaper_files[@]}]}"
    ${pkgs.mpvpaper}/bin/mpvpaper -o "mute=yes loop-file=inf vf=\"$mpv_vf\"" -p "$output_name" "$random_wallpaper_file"
  '';

  mkMpvPaperService = monitorName: {
    systemd.user.services."mpvpaper@${monitorName}" = {
      Unit = {
        Description = "Animated wallpaper daemon for Sway %I output";
        PartOf = "sway-session.target";
        Requires = "sway-session.target";
        After = "sway-session.target";
      };

      Service = {
        Type = "simple";
        ExecStart = "${mpvpaper_set_for_output}/bin/mpvpaper_set_for_output \"${monitorName}\"";
      };
    };
  };
in
  (mkMpvPaperService "GIGA-BYTE")
  // (mkMpvPaperService "LG")
  // {
    home.packages = with pkgs; [playerctl mpvpaper_set_for_output lock_command];

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
      settings = [
        {
          profile.name = "desktop";
          profile.outputs = [
            {
              criteria = gigabyte_4k_monitor;
              position = "1409,720";
            }
            {
              criteria = lg_dualup_monitor;
              position = "5249,414";
            }
          ];
        }
      ];
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
            lg_dualup_monitor
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
            gigabyte_4k_monitor
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
