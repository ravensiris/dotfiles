{ pkgs, lib, ... }:

{
  imports = [ ./i3status-rust.nix ];
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      workspaceAutoBackAndForth = true;
      # output = {
      #   HDMI-A-1 = {
      #     position = "0,0";
      #   };
      #   DVI-D-1 = {
      #     position = "2560,550";
      #   };
      # };
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
        # Lock
        # "${modifier}+Shift+l" = ''
        #   exec ${pkgs.procps}/bin/pgrep swayidle || \
        #     ${pkgs.swayidle}/bin/swayidle -w \
        #       timeout 1 \
        #         '${pkgs.swaylock}/bin/swaylock -e -f -c 000000 -t' \
        #       timeout 2 \
        #         '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
        #       resume \
        #         '${pkgs.sway}/bin/swaymsg "output * dpms on"; \
        #         ${pkgs.killall}/bin/killall swayidle' '';
      };
      window = {
        titlebar = false;
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
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "HDMI-A-1";
        }
        {
          workspace = "2";
          output = "HDMI-A-1";
        }
        {
          workspace = "3";
          output = "HDMI-A-1";
        }
        {
          workspace = "4";
          output = "HDMI-A-1";
        }
        {
          workspace = "5";
          output = "HDMI-A-1";
        }
        {
          workspace = "6";
          output = "DVI-D-1";
        }
        {
          workspace = "7";
          output = "DVI-D-1";
        }
        {
          workspace = "8";
          output = "DVI-D-1";
        }
        {
          workspace = "9";
          output = "DVI-D-1";
        }
        {
          workspace = "10";
          output = "DVI-D-1";
        }
      ];
    };
  };
}
