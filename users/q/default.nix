{ lib, pkgs, inputs, ... }:
{
  users.users.q = {
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  home-manager.users.q = { profiles, ... }: {
    imports = [ profiles.doom-emacs ];
    home.packages = with pkgs; [ (nerdfonts.override { fonts = [ "VictorMono" "FiraCode" ]; }) ];
    programs.mpv.enable = true;
    home.persistence."/nix/persist/home/q" = {
      files = [
        ".ssh/id_rsa"
        ".ssh/id_rsa.pub"
      ];
    };
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
