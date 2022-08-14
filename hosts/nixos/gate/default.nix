{ suites, lib, config, pkgs, profiles, callPackage, ... }:

{
  ### root password is empty by default ###
  imports = suites.base ++
    suites.impermanence ++
    suites.audio ++
    suites.amdgpu ++
    suites.i3wm ++
    suites.vfio-amdcpu-nvidiaguest ++ (with profiles;
    [
    ]);

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/libvirt"
    ];
  };

  programs.dconf.enable = true;

  virtualisation.passthrough = {
    enable = true;
    ids = [ "10de:2484" "10de:228b" ];
  };

  environment.systemPackages = with pkgs; [
    ddccontrol
  ];

  services.ddccontrol.enable = true;

  # programs.sway.enable = true;

  networking.useDHCP = lib.mkDefault true;

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

    luks.devices."windows" = {
      device = "/dev/disk/by-uuid/3299548d-f3f7-45f9-8e22-1ebeec3348d9";
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
  system.stateVersion = "22.05";
}
