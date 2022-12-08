{ config, lib, pkgs, ... }:

{
  programs.fuse.userAllowOther = true;

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "/dev/vg_root/lv_nixos";
  };

  fileSystems."/etc/nixos" = {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/boot/EFI" = {
    device = "/dev/disk/by-uuid/3463-257A";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/vg_root/lv_swap"; }];
}
