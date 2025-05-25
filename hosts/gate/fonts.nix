{pkgs, ...}: {
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs;
    [
      migu
      baekmuk-ttf
      nanum
      noto-fonts-emoji
      twemoji-color-font
      openmoji-color
      twitter-color-emoji
      mno16
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  fonts.fontconfig = {
    defaultFonts = {
      emoji = ["Noto Color Emoji" "OpenMoji Color"];
    };
  };
}
