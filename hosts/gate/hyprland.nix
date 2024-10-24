{
  pkgs,
  hyprland,
  ...
}: {
  environment.systemPackages = with pkgs; [wl-clipboard];

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  hardware.opengl = {
    package = pkgs.unstable.mesa.drivers;

    # if you also want 32-bit support (e.g for Steam)
    driSupport32Bit = true;
    package32 = pkgs.unstable.pkgsi686Linux.mesa.drivers;
  };
}
