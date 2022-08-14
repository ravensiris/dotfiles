{ lib, pkgs, inputs, ... }:
{
  users.users.q = {
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  home-manager.users.q = {
    # imports = [ "${inputs.impermanence}/home-manager.nix" ];
    programs.mpv.enable = true;
    home.persistence."/nix/persist/home/q" = { };
    programs.kitty.enable = true;
    programs.firefox.enable = true;
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.kitty}/bin/kitty";
      };
    };
  };
}
