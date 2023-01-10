{ suites, lib, config, pkgs, profiles, callPackage, ... }:

{

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
    extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
    extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';


  home-manager.users.q = {
    xsession.windowManager.i3.config.startup = [
      {
        command = "${pkgs.xwallpaper}/bin/xwallpaper  --output HDMI-A-0 --zoom $(shuf -n1 -e /media/Steiner/Pictures/Wallpapers/Landscape/*)";
        notification = false;
        always = true;
      }
      {
        command = "${pkgs.xwallpaper}/bin/xwallpaper --output HDMI-A-1 --zoom $(shuf -n1 -e /media/Steiner/Pictures/Wallpapers/Portrait/*)";
        notification = false;
        always = true;
      }
    ];
  };

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
  boot.initrd.kernelModules = [ "dm-snapshot" "i2c-dev" "i2c-piix4" ];

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/libvirt"
      "/var/lib/docker"
      "/var/lib/cups"
      "/var/lib/private/navidrome"
    ];
  };

  programs.dconf.enable = true;

  systemd.user.services.rgbSetup = {
    script = ''
      openrgb -c 0
    '';

    wantedBy = ["multi-user.target"];
  };

  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/pci0000:00/0000:00:03.1/0000:09:00.0
      DEVNAME=hwmon0=amdgpu
      FCTEMPS=hwmon0/pwm1=hwmon0/temp1_input
      FCFANS= hwmon0/pwm1=
      MINTEMP=hwmon0/pwm1=55
      MAXTEMP=hwmon0/pwm1=75
      MINSTART=hwmon0/pwm1=150
      MINSTOP=hwmon0/pwm1=0
    '';
  };

  virtualisation.passthrough = {
    enable = true;
    ids = [ "10de:2484" "10de:228b" ];
  };

  environment.systemPackages =

    let
      ubpm = pkgs.appimageTools.wrapType2 {
        # or wrapType1
        name = "ubpm";
        src = pkgs.fetchurl {
          url = "https://codeberg.org/attachments/11f187b8-18f8-48bc-9be7-5cc208fed505";
          sha256 = "sha256-B7auOoz24yV+RaVTDyLfCLlR+PERAuLxC6y9S+8AU0E=";
        };
        extraPkgs = pkgs: with pkgs; [ ];
      };
    in
    [ ubpm ] ++
    (with pkgs; [
      ddccontrol
      docker-compose
      jmtpfs
      libguestfs-with-appliance
      ubpm
      openrgb
      lm_sensors
    ]);

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/media/Steiner/Music";
    };
  };

  networking.firewall.interfaces."br0" = {
    allowedTCPPorts = [4533];
  };


  programs.adb.enable = true;

  services.udev.packages = with pkgs; [ qmk-udev-rules ];

  services.udev.extraRules = ''
    #---------------------------------------------------------------#
    #  OpenRGB udev rules                                           #
    #                                                               #
    #   Adam Honse (CalcProgrammer1)                    5/29/2020   #
    #---------------------------------------------------------------#

    #---------------------------------------------------------------#
    #  User I2C/SMBus Access                                        #
    #---------------------------------------------------------------#
    KERNEL=="i2c-[0-99]*", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  Super I/O Access                                             #
    #---------------------------------------------------------------#
    KERNEL=="port", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  User hidraw Access                                           #
    #---------------------------------------------------------------#
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  AMD Wraith Prism                                             #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0051", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  Aorus Devices                                                #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1044", ATTR{idProduct}=="7a42", TAG+="uaccess"
    #---------------------------------------------------------------#
    #  Cooler Master Peripheral Devices                             #
    #                                                               #
    #  Mice:                                                        #
    #       Cooler Master MM711                                     #
    #       Cooler Master MM720                                     #
    #  Mousemats:                                                   #
    #       Cooler Master MP750                                     #
    #  Controllers:                                                 #
    #       ARGB Device                                             #
    #       Small ARGB Device                                       #
    #  Graphics Cards:                                              #
    #       Radeon RX6000 Series Reference Cards                    #
    #  Keyboards:                                                   #
    #       Masterkeys Pro L                                        #
    #       Masterkeys Pro L White                                  #
    #       Masterkeys Pro S                                        #
    #       Masterkeys MK750                                        #
    #       Masterkeys SK630                                        #
    #       Masterkeys SK650                                        #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0101", TAG+="uaccess", TAG+="MM711"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0141", TAG+="uaccess", TAG+="MM720"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0109", TAG+="uaccess", TAG+="MP750_XL"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0107", TAG+="uaccess", TAG+="MP750_L"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0105", TAG+="uaccess", TAG+="MP750_M"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="1011", TAG+="uaccess", TAG+="ARGB"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="1000", TAG+="uaccess", TAG+="Small_ARGB"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="004f", TAG+="uaccess", TAG+="RGB"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="014d", TAG+="uaccess", TAG+="Radeon_6000"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="003b", TAG+="uaccess", TAG+="Masterkeys_Pro_L"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0047", TAG+="uaccess", TAG+="Masterkeys_Pro_L_White"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="003c", TAG+="uaccess", TAG+="Masterkeys_Pro_S"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0067", TAG+="uaccess", TAG+="Masterkeys_MK750"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0089", TAG+="uaccess", TAG+="Masterkeys_SK630"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="008d", TAG+="uaccess", TAG+="Masterkeys_SK650"

    #---------------------------------------------------------------#
    #  Logitech Peripheral Devices                                  #
    #                                                               #
    #   Keyboards:                                                  #
    #       Logitech G213                                           #
    #       Logitech G512                                           #
    #       Logitech G512 RGB                                       #
    #       Logitech G610 #1                                        #
    #       Logitech G610 #2                                        #
    #       Logitech G810 #1                                        #
    #       Logitech G810 #2                                        #
    #       Logitech G813                                           #
    #       Logitech G815                                           #
    #       Logitech G915                                           #
    #       Logitech G Pro                                          #
    #                                                               #
    #  Mice:                                                        #
    #       Logitech G203 Prodigy                                   #
    #       Logitech G203 Lightsync                                 #
    #       Logitech G303                                           #
    #       Logitech G403 Prodigy                                   #
    #       Logitech G403 Hero                                      #
    #       Logitech G502 Proteus Spectrum                          #
    #       Logitech G502 Hero                                      #
    #       Logitech G502 Wireless                                  #
    #       Logitech G703 Wireless                                  #
    #       Logitech G703 Hero Wireless                             #
    #       Logitech G900 Wireless                                  #
    #       Logitech G903 Wireless                                  #
    #       Logitech G Lightspeed Wireless Gaming Mouse             #
    #       Logitech G Pro Wireless Gaming Mouse (Wired)            #
    #       Logitech G Pro Hero Gaming Mouse (Wired)                #
    #                                                               #
    #  Mousemats:                                                   #
    #       Logitech G Powerplay Mousepad with Lightspeed           #
    #                                                               #
    #  Speakers:                                                    #
    #       Logitech G560                                           #
    #                                                               #
    #  Headsets:                                                    #
    #       Logitech G933                                           #
    #                                                               #
    #  Joysticks:                                                   #
    #       Logitech Rhino X56 Hotas (Throttle and Stick)           #
    #                                                               #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c336", TAG+="uaccess", TAG+="G213"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c342", TAG+="uaccess", TAG+="G512"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c33c", TAG+="uaccess", TAG+="G512_RGB"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c333", TAG+="uaccess", TAG+="G610"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c338", TAG+="uaccess", TAG+="G610"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c331", TAG+="uaccess", TAG+="G810"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c337", TAG+="uaccess", TAG+="G810"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c339", TAG+="uaccess", TAG+="G_Pro"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c232", TAG+="uaccess", TAG+="G813"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c33f", TAG+="uaccess", TAG+="G815"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c335", TAG+="uaccess", TAG+="G910"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c541", TAG+="uaccess", TAG+="G915_Receiver"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c33e", TAG+="uaccess", TAG+="G915_Wired"

    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c084", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c092", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c083", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c08f", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c082", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="405d", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c332", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c08b", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c08d", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="407f", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c087", TAG+="uaccess", TAG+="G703"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="4070", TAG+="uaccess", TAG+="G703_Virtual"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c090", TAG+="uaccess", TAG+="G703_Hero"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="4086", TAG+="uaccess", TAG+="G703_Hero_Virtual"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c081", TAG+="uaccess", TAG+="G900_wired"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="4053", TAG+="uaccess", TAG+="G900_wireless"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c086", TAG+="uaccess", TAG+="G903_wired"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c091", TAG+="uaccess", TAG+="G903_V2_wired"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="4067", TAG+="uaccess", TAG+="G903_wireless"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="4087", TAG+="uaccess", TAG+="G903_V2_wireless"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c085", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c08c", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c088", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="4079", TAG+="uaccess"

    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c53a", TAG+="uaccess", TAG+="Powerplay_Mat_Reciever"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="405f", TAG+="uaccess", TAG+="Powerplay_Mat_Virtual"

    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0a78", TAG+="uaccess", TAG+="G560"

    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0a5b", TAG+="uaccess", TAG+="G933"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0ab5", TAG+="uaccess", TAG+="G733"

    SUBSYSTEMS=="usb", ATTR{idVendor}=="0738", ATTR{idProduct}=="2221", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0738", ATTR{idProduct}=="a221", TAG+="uaccess"
    #---------------------------------------------------------------#
    #  Gigabyte/Aorus RGB Fusion 2 USB                              #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="8297", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="5702", TAG+="uaccess"
  '';

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
