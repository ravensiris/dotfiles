{pkgs, ...}: {
  environment.systemPackages = with pkgs; [wl-clipboard];

  programs.hyprland = {
    enable = true;
    # portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
