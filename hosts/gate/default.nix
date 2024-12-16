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
    ./libvirt.nix
    ./audio.nix
    ./hyprland.nix
    ./syncthing.nix
    ./printing.nix
    ./fonts.nix
  ];

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # for Bambu LAN only mode discovery
  networking.firewall.allowedUDPPorts = [2021];

  hardware.graphics.enable = true;
  programs.adb.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.kdeconnect.enable = true;

  age.identityPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
  time.timeZone = "Europe/Warsaw";

  age.secrets.share-bucket.file = ../../secrets/share-bucket.age;
  s3fs.share = {
    mountPath = "/media/share";
  };

  environment.systemPackages = with pkgs; [
    agenix.packages.x86_64-linux.default
    unstable.devenv
    iotop
    libguestfs-with-appliance
    scrcpy
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.input-overlay
    obs-studio-plugins.looking-glass-obs
    obs-studio-plugins.obs-pipewire-audio-capture
    v4l-utils
    android-file-transfer
    ddcutil
    s3fs
  ];

  nix.settings.trusted-users = ["q"];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org" "https://devenv.cachix.org"];
  nix.settings.trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  # nix.settings.trusted-substituters = [];

  networking.hostName = "gate";
  system.stateVersion = "24.05";
}
