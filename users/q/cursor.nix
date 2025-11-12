{pkgs, ...}: {
  home.packages = with pkgs; [
    unstable.code-cursor
  ];

  home.persistence."/nix/persist/home/q".directories = [
    ".config/Cursor"
  ];
}
