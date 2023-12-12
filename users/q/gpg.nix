{pkgs, ...}: {
  programs.gpg.enable = true;
  home.packages = with pkgs; [
    pinentry-qt
    (pass.withExtensions (ext: with ext; [pass-otp]))
  ];

  home.persistence."/nix/persist/home/q".directories = [
    ".gnupg"
    ".password-store"
  ];
}
