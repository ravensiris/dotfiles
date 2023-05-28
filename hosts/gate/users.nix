{...}: {
  imports = [../../users/q/default.nix];
  environment.persistence."/nix/persist".users.q.directories = [
      "Projects"
      "Documents"
      "Sync"
      ".config/syncthing"
      "Music"
    ];
    
}
