{ lib, pkgs, inputs, ... }:
{
  users.users.q = {
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  home-manager.users.q = { profiles, ... }: {
    imports = [ profiles.doom-emacs profiles.wm.i3 ];
    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "VictorMono" "FiraCode" ]; })
      font-awesome
    ];
    programs.mpv.enable = true;
    home.persistence."/nix/persist/home/q" = {
      files = [
        ".ssh/id_rsa"
        ".ssh/id_rsa.pub"
      ];
    };
    programs.kitty.enable = true;
    programs.firefox.enable = true;
  };
}
