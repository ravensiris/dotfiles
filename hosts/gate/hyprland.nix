{pkgs, ...}: {
  environment.systemPackages = with pkgs; [wl-clipboard];
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
}
