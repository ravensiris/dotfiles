{ config, lib, pkgs, ... }:

let
  swaylock_cmd = pkgs.writeScriptBin "swaylock_pretty" ''
    if [ -d "/media/Steiner/Pictures/Wallpapers" ]; then
      ${pkgs.swaylock}/bin/swaylock swaylock -i HDMI-A-1:$(shuf -n1 -e /media/Steiner/Pictures/Wallpapers/Landscape/*) -i HDMI-A-2:$(shuf -n1 -e /media/Steiner/Pictures/Wallpapers/Portrait/*)
    elif [ -d "~/Pictures/Wallpapers" ]; then
      ${pkgs.swaylock}/bin/swaylock swaylock -i eDP-1 bg $(shuf -n1 -e ~/Pictures/Wallpapers/Landscape/*)
    fi
  '';
in
{
  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };
  };

  home-manager.users.q = {
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        {
          event = "lock";
          command = "lock";
        }
      ];
      timeouts = [
        {
          timeout = 120;
          command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
          resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
        }
        {
          timeout = 360;
          command = "${swaylock_cmd}/bin/swaylock_pretty";
        }
      ];
    };
    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks =
            [
              {
                block = "custom";
                command = ''
                  output=$(cat /proc/asound/Audio/pcm0p/sub0/hw_params | grep rate | awk -F': *| *[(]' '{
                      if ($2 == "44100") {
                          state = "Idle"
                      } else if ($2 == "48000") {
                          state = "Good"
                      } else if ($2 == "96000") {
                          state = "Warning"
                      } else if ($2 == "192000") {
                          state = "Danger"
                      } else {
                          state = "Info"
                      }
                      printf "{\"text\": \"%.1f kHz\", \"icon\": \"music\", \"state\": \"%s\"}\n", $2/1000, state
                  }')

                  if [ -z "$output" ]; then
                      echo '{"text": "Silence", "icon": "music", "state": "Info"}'
                  else
                      echo "$output"
                  fi
                '';
                interval = 15;
                json = true;
                # watch_files = ["/proc/asound/Audio/pcm0p/sub0/hw_params"];
              }
              {
                block = "disk_space";
                format = "{icon} <b>{used}</b>/{total}";
                info_type = "available";
                interval = 60;
                path = "/nix/persist";
                unit = "GB";
                alert = 10.0;
                warning = 20.0;
              }
              {
                block = "sound";
                format = "{volume}";
                step_width = 1;
                on_click = "${pkgs.alsa-utils}/bin/amixer set Master toggle";
                headphones_indicator = true;
              }
              {
                block = "sound";
                format = "{volume}";
                step_width = 1;
                device_kind = "source";
                on_click = "${pkgs.alsa-utils}/bin/amixer set Capture toggle";
              }
              {
                block = "memory";
                format_mem = "<b>{mem_used}</b> /{mem_total}";
                display_type = "memory";
                icons = true;
                clickable = false;
                interval = 5;
                warning_mem = 80;
                warning_swap = 80;
                critical_mem = 95;
                critical_swap = 95;
                theme_overrides = {
                  idle_bg = "#2aa198";
                  idle_fg = "#002b36";
                };
              }
              {
                block = "cpu";
                interval = 1;
                format = "{utilization} {frequency}";
                theme_overrides = {
                  idle_bg = "#268bd2";
                  idle_fg = "#002b36";
                };
              }
              {
                block = "time";
                interval = 15;
                format = "%a %d/%m <span font_weight='900' font_family='Nova Mono'>%R</span>";
                theme_overrides = {
                  idle_bg = "#6c71c4";
                  idle_fg = "#002b36";
                };
              }
            ];
          settings = {
            icons = "material-nf";
            theme = "solarized-dark";
            icons_format = " {icon} ";
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
        terminal = "kitty";
        menu = "${pkgs.fuzzel}/bin/fuzzel";
        startup = [
          {
            command = "XDG_CONFIG_HOME=/home/q/.config ${pkgs.swaynotificationcenter}/bin/swaync";
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
          "${modifier}+l" = "exec ${swaylock_cmd}/bin/swaylock_pretty";

          # Quick launch
          "${modifier}+m" = "exec emacsclient -c";

          "${modifier}+s" = "layout default";
          "${modifier}+w" = "layout default";
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
          names = [ "VictorMono Nerd Font" ];
          style = "Regular";
          size = 18.0;
        };
        bars = [
          (lib.mkOptionDefault {
            position = "top";
            statusCommand =
              "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            fonts = {
              names = [ "VictorMono Nerd Font" ];
              size = 12.0;
            };
          })
        ];
      };
    };
  };

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty? ]] && sudo /run/current-system/sw/bin/lock this
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

  security.polkit.enable = true;
  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth sufficient pam_unix.so   likeauth try_first_pass
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok sha512

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  fonts.fonts = with pkgs; [
    koruri
    noto-fonts-emoji
    twemoji-color-font
    openmoji-color
    twitter-color-emoji
  ];
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway"; # https://github.com/emersion/xdg-desktop-portal-wlr/issues/20
      XDG_SESSION_TYPE = "wayland"; # https://github.com/emersion/xdg-desktop-portal-wlr/pull/11
    };

  environment.systemPackages = with pkgs; [
    swaylock
    swaylock_cmd
    swaynotificationcenter
    xdg-utils
    glib
    dracula-theme # gtk themeracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    gnome3.adwaita-icon-theme  # default gnome cursors
    xdg-desktop-portal-wlr
    xorg.xeyes
  ];
}
