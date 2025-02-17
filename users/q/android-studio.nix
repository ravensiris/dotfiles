{...}: {
  home.persistence."/nix/persist/home/q".directories = [
    ".cache/Google"
    ".config/Google"
    ".local/share/Google"

    ".config/java"

    ".config/android"
    ".local/share/android"
  ];
}
