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
    ./libvirt.nix
    ./audio.nix
    ./sway.nix
    ./syncthing.nix
  ];

  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  programs.adb.enable = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  age.identityPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
  time.timeZone = "Europe/Warsaw";

  environment.systemPackages = with pkgs; [
    devenv.packages.x86_64-linux.devenv
    agenix.packages.x86_64-linux.default
    iotop
    libguestfs-with-appliance
    scrcpy
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.input-overlay
    obs-studio-plugins.looking-glass-obs
    obs-studio-plugins.obs-pipewire-audio-capture
    v4l-utils
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
  nix.settings.trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  nix.settings.trusted-substituters = ["https://devenv.cachix.org"];

  networking.hostName = "gate";
  system.stateVersion = "23.11";
}
