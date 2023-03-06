{ pkgs, lib, ... }:

{
  imports = [ ./i3status-rust.nix ];
  xsession.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      workspaceAutoBackAndForth = true;
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
    };
  };
}
