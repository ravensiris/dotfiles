{ suites, lib, config, pkgs, profiles, callPackage, ... }:

{
  imports = suites.base
    ++ suites.impermanence
    ++ suites.audio
    ++ suites.i3wm
    ++ suites.dev
    ++ [ ./network.nix ./boot.nix ./power.nix ./video.nix ./device.nix ./storage.nix ./persistence.nix ./package.nix ./docker ];

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


  home-manager.users.q = {
    xsession.windowManager.i3.config.startup = [
      {
        command = "${pkgs.xwallpaper}/bin/xwallpaper --output eDP --zoom $(shuf -n1 -e ~/Pictures/Wallpapers/Landscape/*)";
        notification = false;
        always = true;
      }
    ];
  };


  programs.dconf.enable = true;

  system.stateVersion = "22.05";
}
