# stolen from https://github.com/raexera/yuki
{
  pkgs,
  lib,
  ...
}: let
  basePalette = {
    base = "rgba(25, 23, 36, 1)";
    surface = "rgba(31, 29, 46, 1)";
    overlay = "rgba(38, 35, 58, 1)";
    muted = "rgba(110, 106, 134, 1)";
    subtle = "rgba(144, 140, 170, 1)";
    text = "rgba(224, 222, 244, 1)";
    love = "rgba(235, 111, 146, 1)";
    gold = "rgba(246, 193, 119, 1)";
    rose = "rgba(235, 188, 186, 1)";
    pine = "rgba(49, 116, 143, 1)";
    foam = "rgba(156, 207, 216, 1)";
    iris = "rgba(196, 167, 231, 1)";
    highlightLow = "rgba(33, 32, 46, 1)";
    highlightMed = "rgba(64, 61, 82, 1)";
    highlightHigh = "rgba(82, 79, 103, 1)";
  };

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
              # days = "<span color='${basePalette.muted}'><b>{}</b></span>";
              # months = "<span color='${basePalette.text}'><b>{}</b></span>";
              # today = "<span color='${basePalette.text}'><b><u>{}</u></b></span>";
              # weekdays = "<span color='${basePalette.pine}'><b>{}</b></span>";
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
        color: ${basePalette.text};
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
        background: ${basePalette.surface};
        border-radius: 8px;
      }

      menu separator {
        background: ${basePalette.overlay};
      }

      menu menuitem {
        background: transparent;
        padding: 0.5rem;
        transition: 200ms;
      }

      menu menuitem:hover {
        background: ${basePalette.highlightMed};
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
        background: ${basePalette.surface};
        border-radius: 16px;
        min-width: 5rem;
      }

      scale highlight,
      scale progress,
      progressbar highlight,
      progressbar progress {
        background: ${basePalette.overlay};
        border-radius: 16px;
        min-height: 0.5rem;
      }

      /* Tooltip */
      tooltip {
        background: ${basePalette.surface};
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
        background: ${basePalette.overlay};
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
        background: ${basePalette.pine};
        color: ${basePalette.overlay};
        padding: 0.5rem;
      }

      /* Hyprland Workspaces */
      #workspaces {
        padding: 0.5rem 0.75rem;
      }

      #workspaces button {
        background: ${basePalette.text};
        border-radius: 100%;
        margin-right: 0.75rem;
        min-width: 1.525rem;
        transition: 200ms linear;
      }

      #workspaces button:last-child {
        margin-right: 0;
      }

      #workspaces button:hover {
        background: lighter(${basePalette.text});
      }

      #workspaces button.empty {
        background: ${basePalette.muted};
      }

      #workspaces button.empty:hover {
        background: lighter(${basePalette.muted});
      }

      #workspaces button.urgent {
        background: ${basePalette.love};
      }

      #workspaces button.urgent:hover {
        background: lighter(${basePalette.love});
      }

      #workspaces button.special {
        background: ${basePalette.rose};
      }

      #workspaces button.special:hover {
        background: lighter(${basePalette.rose});
      }

      #workspaces button.active {
        background: ${basePalette.pine};
      }

      #workspaces button.active:hover {
        background: lighter(${basePalette.pine});
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
        background: ${basePalette.love};
      }

      /* Network */
      #network.disconnected {
        color: ${basePalette.love};
      }

      /* Pulseaudio */
      #pulseaudio.muted {
        color: ${basePalette.love};
      }

      #pulseaudio-slider highlight,
      #backlight-slider highlight {
        background: ${basePalette.text};
      }

      /* Battery */
      #battery.charging,
      #battery.plugged {
        color: ${basePalette.foam};
      }

      #battery.critical:not(.charging) {
        color: ${basePalette.love};
        animation: blink 0.5s steps(12) infinite alternate;
      }

      /* Keyframes */
      @keyframes blink {
        to {
          color: ${basePalette.text};
        }
      }
    '';
  };
}
