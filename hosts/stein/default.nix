{
  lib,
  pkgs,
  agenix,
  ...
}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/nvme0n1"];
    })
    ./boot.nix
    ./persistence.nix
    ./users.nix
    ./docker.nix
    ./gpg.nix
    ./network.nix
    ./audio.nix
    ./sway.nix
    ./udev.nix
  ];

  hardware.keyboard.qmk.enable = true;
  hardware.sane.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  services.fprintd = {
    enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  services.tlp.enable = true;

  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  swapDevices = [
    {
      device = "/dev/mapper/vg_root-lv_swap";
    }
  ];

  age.identityPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
  time.timeZone = "Europe/Warsaw";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.packages = [pkgs.OVMFFull];
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  programs.dconf.enable = true;

  users.users.q.extraGroups = ["libvirtd"];
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    unstable.devenv
    agenix.packages.x86_64-linux.default
    gutenprint
    (brave.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
      ];
    })
    virt-manager
    brightnessctl
    wdisplays
    swww
    powertop
    meshlab
    f3d
    openscad
    jmtpfs
    iotop
    (xsane.override {gimpSupport = true;})
    hplip
  ];
  hardware.sane.extraBackends = [pkgs.sane-airscan];

  fonts.packages = with pkgs; [
    migu
    baekmuk-ttf
    nanum
    noto-fonts-emoji
    twemoji-color-font
    openmoji-color
    twitter-color-emoji
    nerdfonts
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org"];
  nix.settings.trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  networking.hostName = "stein";
  system.stateVersion = "23.11";
}
