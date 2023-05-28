{lib, pkgs, ...}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/vda"];
    })
    ./boot.nix
    ./persistence.nix
    ./users.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "gate";
  system.stateVersion = "22.11";
}
