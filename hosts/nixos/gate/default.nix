{ suites, ... }:
{
  ### root password is empty by default ###
  imports = suites.base;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = true;

  # hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  # high-resolution display
  hardware.video.hidpi.enable = true;

  boot.initrd = {
    luks.devices."root" = {
      device = "/dev/disk/by-uuid/f35ee9fc-4d99-47de-936f-8c53e2b78b4a";
      preLVM = true;
      # keyFile = "/keyfile0.bin";
      allowDiscards = true;
    };

    luks.devices."data" = {
      device = "/dev/disk/by-uuid/88001461-3665-4bdd-bf20-c0ca0a24abf9";

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

  networking.networkmanager.enable = true;

  # TODO: save passwords using agenix
  users.mutableUsers = false;
  users.users.root.initialPassword = "arstarst";

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/vg/root";
      fsType = "ext4";
    };

  fileSystems."/media/Steiner" =
    {
      device = "/dev/hdd-vg/data";
      fsType = "btrfs";
      options = [ "compress=zlib:6" ];
    };

  fileSystems."/etc/nixos" =
    {
      device = "/nix/persist/etc/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/var/log" =
    {
      device = "/nix/persist/var/log";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/boot/EFI" =
    {
      device = "/dev/disk/by-uuid/052E-D88B";
      fsType = "vfat";
    };
}
