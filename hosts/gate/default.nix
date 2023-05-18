{lib, ...}: {
  disko.devices = import ./disk.nix {
    inherit lib;
  };

  users.mutableUsers = false;
  users.users.q = {
    # passwordFile = "/run/agenix/qPassword";
    password = "arstarst";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" "adbusers" "input" ];
  };

  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
  };

  system.stateVersion = "22.11";
}
