{ suites, lib, config, pkgs, profiles, callPackage, ... }:

{
  imports = suites.base
    ++ suites.impermanence
    ++ suites.audio
    ++ suites.dev
    ++ [ profiles.virt.common ]
    ++ [ ./network.nix ./boot.nix ./power.nix ./video.nix ./device.nix ./storage.nix ./persistence.nix ./package.nix ./docker ./printing.nix ./udev.nix ./memory.nix ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  time.timeZone = "Europe/Warsaw";

  security.polkit.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
    extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
    extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.extra-substituters = [
    "https://nrdxp.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];


  home-manager.users.q = {
    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks =
            [
              {
                block = "keyboard_layout";
                driver = "sway";
                on_click = ''setxkbmap $(setxkbmap -print | awk -F"+" '/xkb_symbols/ {if($2 == "us") print "pl"; else print "us";}')'';
                format = "⌨ {layout}";
                interval = 1;
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
                block = "xrandr";
                icons = true;
                resolution = false;
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
      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "kitty";
        startup = [
          {
            command = "${pkgs.sway}/bin/swaymsg -s $SWAYSOCK output eDP-1 bg $(shuf -n1 -e ~/Pictures/Wallpapers/Landscape/*) fill";
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
          "${modifier}+h" = "layout default";

          # Quick launch
          "${modifier}+m" = "exec emacsclient -c";
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

  programs.dconf.enable = true;

  system.stateVersion = "22.11";
}
