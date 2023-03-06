{ config, lib, pkgs, ... }:

{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks =
          [
            {
              block = "keyboard_layout";
              driver = "setxkbmap";
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
}
