{ config, lib, pkgs, ... }:

{
  services.earlyoom = {
      enable = true;
      freeSwapThreshold = 2;
      freeMemThreshold = 2;
      extraArgs = [
          "-g" "--avoid '^(X|i3|konsole|kwin)$'"
          "--prefer '^(electron|libreoffice|gimp)$'"
      ];
  };
}
