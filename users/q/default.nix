{...}: {
  users.mutableUsers = false;
  users.users.q = {
    # passwordFile = "/run/agenix/qPassword";
    password = "arstarst";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input"];
  };

  home-manager.users.q = {pkgs, ...}: {
    home.packages = [pkgs.neovim];
    home.stateVersion = "22.11";
  };
}
