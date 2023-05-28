{
  lib,
  pkgs,
  ...
}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/vda"];
    })
    ./boot.nix
    ./persistence.nix
    ./users.nix
  ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      fira
      fira-mono
      line-awesome
      google-fonts
      inconsolata # monospaced
      libertine
      mononoki
      nerdfonts
      open-dyslexic
      source-code-pro
      source-sans-pro
      source-serif-pro
      ttf_bitstream_vera
      ubuntu_font_family # Ubuntu fonts
      unifont # some international languages
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

  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "gate";
  system.stateVersion = "22.11";
}
