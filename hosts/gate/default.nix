{
  lib,
  pkgs,
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
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = ["Source Code Pro"];
        sansSerif = ["Source Sans Pro"];
        serif = ["Source Serif Pro"];
      };
    };
  };

  programs.fish.enable = true;
  programs.sway = {
    enable = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "gate";
  system.stateVersion = "23.05";
}
