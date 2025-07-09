{pkgs, ...}: {
  home.packages = with pkgs; [
    code-cursor
  ];

  home.persistence."/nix/persist/home/q".directories = [
    ".config/Cursor"
  ];
}
