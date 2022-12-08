{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  boot.initrd = {
    luks.devices."root" = {
      device = "/dev/disk/by-uuid/712330dd-9d2b-4e59-a333-cf38304da909";
      preLVM = true;
      allowDiscards = true;
    };
  };

  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/EFI";
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
  };
}
