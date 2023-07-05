{
  config,
  lib,
  ...
}: let
  cfg = config.virtualisation.passthrough;
in {
  options.virtualisation.passthrough = {
    enable = lib.mkEnableOption "Passthrough given PCI ids.";

    ids = lib.mkOption {
      type = with lib.types; listOf string;
      description = "List of PCI ids.";
      example = ["10de:2484" "10de:228b"];
    };
  };

  config = let
    ids = builtins.concatStringsSep "," cfg.ids;
  in
    lib.mkIf cfg.enable {
      boot.extraModprobeConfig = "options vfio-pci ids=${ids}";
    };
}
