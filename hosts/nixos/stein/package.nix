{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    tenacity
    gnupg
    wineWowPackages.waylandFull
    winetricks
    bottles
    (lutris.override {
          extraLibraries =  pkgs: [
            curlFull
            libnghttp2
            winetricks
            gnutls
            jansson
          ];
        })
    pcsx2
    qbittorrent
    easyeffects
    libreoffice
    gimp
    inkscape
    devenv
  ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "q" ];

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
