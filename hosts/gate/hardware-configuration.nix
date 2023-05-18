{
  config,
  lib,
  pkgs,
  impermanence,
  disko,
  ...
}: {
  disko.devices = import ./disk.nix {
    inherit lib;
  };

  boot.loader.grub = {
    devices = [ "/dev/vda" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  system.stateVersion = "22.11";
}
