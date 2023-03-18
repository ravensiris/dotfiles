{ suites, lib, config, pkgs, profiles, callPackage, ... }:

{
  imports = suites.base
    ++ suites.impermanence
    ++ suites.audio
    ++ suites.dev
    ++ suites.sway
    ++ [ profiles.virt.common ]
    ++ [ ./network.nix ./boot.nix ./power.nix ./video.nix ./device.nix ./storage.nix ./persistence.nix ./package.nix ./docker ./printing.nix ./udev.nix ./memory.nix ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  home-manager.users.q.wayland.windowManager.sway.config = {
    startup = [
          {
            command = "${pkgs.sway}/bin/swaymsg -s $SWAYSOCK output eDP-1 bg $(shuf -n1 -e ~/Pictures/Wallpapers/Landscape/*) fill";
            always = true;
          }
    ];
  };

  time.timeZone = "Europe/Warsaw";

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
    extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
    extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.extra-substituters = [
    "https://nrdxp.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  programs.dconf.enable = true;

  system.stateVersion = "22.11";
}
