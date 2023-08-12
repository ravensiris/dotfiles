{pkgs, ...}: {
  programs.gpg.enable = true;
  home.packages = with pkgs; [
    pinentry-gnome
  ];

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
  };

  home.persistence."/nix/persist/home/q".directories = [
    ".gnupg"
    ".local/share/password-store"
  ];
}
