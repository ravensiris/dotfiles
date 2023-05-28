{...}: {
  imports = [../../users/q/default.nix];

  # these are host specific
  # for more general ones set them using home-manager
  environment.persistence."/nix/persist" = {
    users.q.directories = [
      "Projects"
      "Documents"
      "Sync"
      ".config/syncthing"
      "Music"
    ];
  };
}
