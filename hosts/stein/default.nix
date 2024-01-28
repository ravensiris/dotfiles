{
  lib,
  pkgs,
  devenv,
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
      device = "/nix/persist/swapfile";
      size = 16 * 1024;
    }
  ];

  age.identityPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
  time.timeZone = "Europe/Warsaw";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.packages = [pkgs.OVMFFull];
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  programs.dconf.enable = true;

  users.users.q.extraGroups = ["libvirtd"];

  environment.systemPackages = with pkgs; [
    devenv.packages.x86_64-linux.devenv
    agenix.packages.x86_64-linux.default
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
  ];

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
