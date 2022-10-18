{ suites, lib, config, pkgs, profiles, callPackage, ... }:

{

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
    extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
    extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';

  ### root password is empty by default ###
  imports = suites.base ++
    suites.impermanence ++
    suites.audio ++
    suites.amdgpu ++
    suites.i3wm ++
    suites.vfio-amdcpu-nvidiaguest ++ (with profiles;
    [
      virt.looking-glass
    ])
    ++ [
    ./virt/qemu-hook.nix
    ./network
    ./input
    ./docker
  ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
  };

  time.timeZone = "Europe/Warsaw";

  networking.hosts = {
    "127.0.0.1" = [ "admin.localhost" ];
  };

  services.distccd = {
    enable = true;
    maxJobs = 20;
    allowedClients = [
      "127.0.0.1"
      "192.168.0.0/16"
    ];
    stats.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.extra-substituters = [
    "https://nrdxp.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  # add for impermanence home
  programs.fuse.userAllowOther = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSSHSupport = true;
  };

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/libvirt"
      "/var/lib/docker"
      "/var/lib/cups"
    ];
  };

  programs.dconf.enable = true;

  virtualisation.passthrough = {
    enable = true;
    ids = [ "10de:2484" "10de:228b" ];
  };

  environment.systemPackages = with pkgs; [
    ddccontrol
    docker-compose
    jmtpfs
    libguestfs-with-appliance
  ];

  services.ddccontrol.enable = true;

  # programs.sway.enable = true;
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

    luks.devices."windows2" = {
      device = "/dev/disk/by-uuid/8e0cefcd-f723-495a-b376-276b8deb0996";
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

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
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
