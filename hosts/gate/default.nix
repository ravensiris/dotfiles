{lib, pkgs, ...}: {

  imports = [
    (import ./disk.nix { disks = ["/dev/vda"]; })
  ];

  users.mutableUsers = false;
  users.users.q = {
    # passwordFile = "/run/agenix/qPassword";
    password = "arstarst";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" "adbusers" "input" ];
  };

  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "i2c-dev" "i2c-piix4" ];

  system.stateVersion = "22.11";
}
