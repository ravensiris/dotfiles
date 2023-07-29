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
    ./qmk.nix
  ];

  age.identityPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
  time.timeZone = "Europe/Warsaw";

  environment.systemPackages = with pkgs; [
    devenv.packages.x86_64-linux.devenv
    agenix.packages.x86_64-linux.default
  ];

  fonts.fonts = with pkgs; [
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
  networking.hostName = "gate";
  system.stateVersion = "23.05";
}
