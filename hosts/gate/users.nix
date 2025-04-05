{
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;

  age.secrets.q.file = ../../secrets/q.age;

  programs.fish.enable = true;
  users.users.q = {
    hashedPasswordFile = config.age.secrets.q.path;
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input" "dialout" "fuse" "media"];
    shell = pkgs.fish;
  };

  # these are host specific
  # for more general ones set them using home-manager
  environment.persistence."/nix/persist" = {
    users.q.directories = [
      "Projects"
      "Documents"
      "Sync"
      ".config/syncthing"
      ".config/jellyfin-mpv-shim"
      "Music"
      "Pictures"
      {
        directory = ".cache";
        mode = "u=rwx,g=,o=";
      }
    ];
  };
}
