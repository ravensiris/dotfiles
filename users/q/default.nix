{ lib, pkgs, ... }:
{
  users.users.q = {
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.q = {
    programs.mpv.enable = true;
    programs.kitty.enable = true;
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.kitty}/bin/kitty";
      };
    };
  };
}
