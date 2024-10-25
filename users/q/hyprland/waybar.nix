# stolen from https://github.com/raexera/yuki
{
  pkgs,
  lib,
  ...
}: let
  colors = {
    foreground = "D8DEE9";

    background = "2E3440";
    background_focus = "373E4C";
    background_dark = "242933";

    cursor = "81A1C1";
    cursor_text = "2E3440";

    accent = "89C1D1";

    normal = {
      black = "3B4252";
      red = "BF616A";
      green = "A3BE8C";
      yellow = "EBCB8B";
      blue = "81A1C1";
      magenta = "B48EAD";
      cyan = "88C0D0";
      white = "E5E9F0";
    };

    bright = {
      black = "4C566A";
      red = "BF616A";
      green = "A3BE8C";
      yellow = "D08770";
      blue = "5E81AC";
      magenta = "B48EAD";
      cyan = "8FBCBB";
      white = "ECEFF4";
    };

    dim = {
      black = "373E4D";
      red = "94545D";
      green = "809575";
      yellow = "B29E75";
      blue = "68809A";
      magenta = "8C738C";
      cyan = "6D96A5";
      white = "AEB3BB";
    };
  };

  xcolors = lib.mapAttrsRecursive (_: color: "#${color}") colors;

  snowflake = builtins.fetchurl rec {
    name = "Logo-${sha256}.svg";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg";
    sha256 = "1cifj774r4z4m856fva1mamnpnhsjl44kw3asklrc57824f5lyz3";
  };

  gigabyteMonitor = "GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190";
  lgMonitor = "LG Electronics LG SDQHD 205NTNH5W679";
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "graphical-session.target";

    settings = [
      {
        layer = "top";
        position = "top";
        exclusive = true;
        fixed-center = true;
        gtk-layer-shell = true;
        spacing = 0;
        margin-top = 4;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = ["image" "hyprland/workspaces" "hyprland/window"];
        modules-center = ["custom/weather" "clock"];
        modules-right = ["tray" "group/network-pulseaudio-backlight-battery" "group/powermenu"];

        "image" = {
          path = snowflake;
          size = 32;
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "";
          on-click = "activate";
          disable-scroll = true;
          # all-outputs = true;
          show-special = true;
          persistent-workspaces = {
            "1" = [gigabyteMonitor];
            "2" = [gigabyteMonitor];
            "3" = [gigabyteMonitor];
            "4" = [gigabyteMonitor];
            "5" = [gigabyteMonitor];
            "6" = [gigabyteMonitor];
            "7" = [lgMonitor];
            "8" = [lgMonitor];
            "9" = [lgMonitor];
          };
        };

        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
        };

        clock = {
          format = "{:%b %d %H:%M}";
          actions = {
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
          tooltip-format = "<span size='32pt'><tt><small>{calendar}</small></tt></span>";
          calendar = {
            format = {
              days = "<span color='${xcolors.bright.black}'><b>{}</b></span>";
              months = "<span color='${xcolors.foreground}'><b>{}</b></span>";
              today = "<span color='${xcolors.foreground}'><b><u>{}</u></b></span>";
              weekdays = "<span color='${xcolors.accent}'><b>{}</b></span>";
            };
            mode = "month";
            on-scroll = 1;
          };
        };

        tray = {
          icon-size = 24;
          show-passive-items = true;
          spacing = 8;
        };

        "group/network-pulseaudio-backlight-battery" = {
          modules = [
            "network"
            "group/audio-slider"
            "group/light-slider"
            "battery"
          ];
          orientation = "inherit";
        };

        network = {
          format-wifi = "󰤨";
          format-ethernet = "󰈀";
          format-disconnected = "";
          tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-ethernet = "Ethernet: {ifname}\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-disconnected = "Disconnected";
        };

        "group/audio-slider" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
            children-class = "audio-slider-child";
            transition-left-to-right = true;
          };
          modules = ["pulseaudio" "pulseaudio/slider"];
        };
        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "󰂯";
          format-muted = "󰖁";
          format-icons = {
            hands-free = "󱡏";
            headphone = "󰋋";
            headset = "󰋎";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          tooltip-format = "Volume: {volume}%";
          on-click = "${pkgs.pamixer}/bin/pamixer --toggle-mute";
          on-scroll-up = "${pkgs.pamixer}/bin/pamixer --decrease 1";
          on-scroll-down = "${pkgs.pamixer}/bin/pamixer --increase 1";
        };
        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        "group/light-slider" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
            children-class = "light-slider-child";
            transition-left-to-right = true;
          };
          modules = ["backlight" "backlight/slider"];
        };
        backlight = {
          format = "{icon}";
          format-icons = ["󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥"];
          tooltip-format = "Backlight: {percent}%";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set +1%";
        };
        "backlight/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        battery = {
          format = "{icon}";
          format-charging = "󱐋";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-plugged = "󰚥";
          states = {
            warning = 30;
            critical = 20;
          };
          tooltip-format = "{timeTo}, {capacity}%";
        };

        "group/powermenu" = {
          drawer = {
            children-class = "powermenu-child";
            transition-duration = 300;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/exit"
            "custom/lock"
            "custom/suspend"
            "custom/reboot"
          ];
          orientation = "inherit";
        };
        "custom/power" = {
          format = "󰐥";
          on-click = "${pkgs.systemd}/bin/systemctl poweroff";
          tooltip = false;
        };
        "custom/exit" = {
          format = "󰈆";
          on-click = "${pkgs.systemd}/bin/loginctl terminate-user $USER";
          tooltip = false;
        };
        "custom/suspend" = {
          format = "󰤄";
          on-click = "${pkgs.systemd}/bin/systemctl suspend";
          tooltip = false;
        };
        "custom/reboot" = {
          format = "󰜉";
          on-click = "${pkgs.systemd}/bin/systemctl reboot";
          tooltip = false;
        };
      }
    ];

    style = ''
      /* Global */
      * {
        all: unset;
        color: ${xcolors.foreground};
        font:
          11pt "Material Design Icons",
          Inter,
          sans-serif;
        font-size: 20px;
      }

      /* Button */
      button {
        box-shadow: inset 0 -0.25rem transparent;
        border: none;
      }

      button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
      }

      /* Menu */
      menu {
        background: ${xcolors.background_dark};
        border-radius: 8px;
      }

      menu separator {
        background: ${xcolors.background};
      }

      menu menuitem {
        background: transparent;
        padding: 0.5rem;
        transition: 200ms;
      }

      menu menuitem:hover {
        background: ${xcolors.background_focus};
      }

      menu menuitem:first-child {
        border-radius: 8px 8px 0 0;
      }

      menu menuitem:last-child {
        border-radius: 0 0 8px 8px;
      }

      menu menuitem:only-child {
        border-radius: 8px;
      }

      /* Scale and Progress Bars */
      scale trough,
      progressbar trough {
        background: ${xcolors.background_dark};
        border-radius: 16px;
        min-width: 5rem;
      }

      scale highlight,
      scale progress,
      progressbar highlight,
      progressbar progress {
        background: ${xcolors.background};
        border-radius: 16px;
        min-height: 0.5rem;
      }

      /* Tooltip */
      tooltip {
        background: ${xcolors.background_dark};
        border-radius: 16px;
      }

      tooltip label {
        margin: 0.5rem;
      }

      /* Waybar */
      window#waybar {
        background: transparent;
      }

      window#waybar.empty #window {
        background: transparent;
        border: none;
      }

      .modules-left {
        padding-left: 0.5rem;
      }

      .modules-right {
        padding-right: 0.5rem;
      }

      /* Modules */
      #workspaces,
      #window,
      #tray,
      #custom-weather,
      #network-pulseaudio-backlight-battery,
      #clock,
      #custom-exit,
      #custom-lock,
      #custom-suspend,
      #custom-reboot,
      #custom-power {
        background: ${xcolors.background};
        border-radius: 8px;
        margin: 0.5rem 0.25rem;
      }

      #image,
      #window,
      #custom-weather,
      #tray,
      #network-pulseaudio-backlight-battery,
      #clock {
        padding: 0 0.75rem;
      }

      #clock {
        font-weight: bold;
      }

      #network,
      #pulseaudio,
      #pulseaudio-slider,
      #backlight,
      #backlight-slider,
      #battery {
        background: transparent;
        padding: 0.5rem;
      }

      #custom-exit,
      #custom-lock,
      #custom-suspend,
      #custom-reboot,
      #custom-power {
        background: ${xcolors.accent};
        color: ${xcolors.background};
        padding: 0.5rem;
      }

      /* Hyprland Workspaces */
      #workspaces {
        padding: 0.5rem 0.75rem;
      }

      #workspaces button {
        background: ${xcolors.foreground};
        border-radius: 100%;
        margin-right: 0.75rem;
        min-width: 1.525rem;
        transition: 200ms linear;
      }

      #workspaces button:last-child {
        margin-right: 0;
      }

      #workspaces button:hover {
        background: lighter(${xcolors.foreground});
      }

      #workspaces button.empty {
        background: ${xcolors.bright.black};
      }

      #workspaces button.empty:hover {
        background: lighter(${xcolors.bright.black});
      }

      #workspaces button.urgent {
        background: ${xcolors.normal.red};
      }

      #workspaces button.urgent:hover {
        background: lighter(${xcolors.normal.red});
      }

      #workspaces button.special {
        background: ${xcolors.normal.blue};
      }

      #workspaces button.special:hover {
        background: lighter(${xcolors.normal.blue});
      }

      #workspaces button.active {
        background: ${xcolors.accent};
      }

      #workspaces button.active:hover {
        background: lighter(${xcolors.accent});
      }

      /* Hyprland Window */
      #window {
        min-width: 1rem;
      }

      /* Systray */
      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background: ${xcolors.normal.red};
      }

      /* Network */
      #network.disconnected {
        color: ${xcolors.normal.red};
      }

      /* Pulseaudio */
      #pulseaudio.muted {
        color: ${xcolors.normal.red};
      }

      #pulseaudio-slider highlight,
      #backlight-slider highlight {
        background: ${xcolors.foreground};
      }

      /* Battery */
      #battery.charging,
      #battery.plugged {
        color: ${xcolors.normal.green};
      }

      #battery.critical:not(.charging) {
        color: ${xcolors.normal.red};
        animation: blink 0.5s steps(12) infinite alternate;
      }

      /* Keyframes */
      @keyframes blink {
        to {
          color: ${xcolors.foreground};
        }
      }
    '';
  };
}
