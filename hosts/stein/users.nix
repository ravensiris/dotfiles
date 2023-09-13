{
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;

  age.secrets.q.file = ../../secrets/q.age;

  programs.fish.enable = true;
  users.users.q = {
    passwordFile = config.age.secrets.q.path;
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input"];
    shell = pkgs.fish;
  };

  # these are host specific
  # for more general ones set them using home-manager
  environment.persistence."/nix/persist" = {
    users.q.directories = [
      "Projects"
      "Documents"
      "Music"
      "Pictures"
      ".config/BraveSoftware"
    ];
  };
}
