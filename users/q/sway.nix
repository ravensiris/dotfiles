{
  lib,
  pkgs,
  ...
}: let
  swww_set_wallpapers_per_output = pkgs.writeScript "swww_set_wallpapers_per_output" ''
    #!${pkgs.bash}/bin/bash

    # Iterate over each image file in the directory
    for image_file in ~/Pictures/Wallpapers/Current/*; do
    	# Get the filename without the directory path and file extension
    	filename=$(basename -- "$image_file")
    	output_name="''${filename%.*}"

    	# Run the swww command with the appropriate output name
    	${pkgs.swww}/bin/swww img -o "$output_name" "$image_file" || continue
    done
  '';
in {
  home.pointerCursor = {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    gtk.enable = true;
    x11.enable = true;
  };
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            alert = 10.0;
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
          }
          {
            block = "battery";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            format = " $icon $1m ";
            interval = 1;
          }
          {
            block = "sound";
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            interval = 60;
          }
        ];
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
      workspaceAutoBackAndForth = true;
      startup = [
        {
          command = "XDG_CONFIG_HOME=/home/q/.config ${pkgs.swaynotificationcenter}/bin/swaync";
          always = true;
        }
        {
          command = "${pkgs.swww}/bin/swww init; ${swww_set_wallpapers_per_output}";
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
      fonts = {
        names = ["VictorMono Nerd Font"];
        style = "Regular";
        size = 18.0;
      };
      bars = [
        (lib.mkOptionDefault {
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = ["VictorMono Nerd Font"];
            size = 12.0;
          };
        })
      ];
    };
  };
}
