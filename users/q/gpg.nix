{pkgs, ...}: {
  programs.gpg.enable = true;
  home.packages = with pkgs; [
    pinentry-gnome
    pass
  ];

  home.persistence."/nix/persist/home/q".directories = [
    ".gnupg"
    ".password-store"
  ];
}
