{pkgs, ...}: {
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    migu
    baekmuk-ttf
    nanum
    noto-fonts-emoji
    twemoji-color-font
    openmoji-color
    twitter-color-emoji
    nerdfonts
  ];

  fonts.fontconfig = {
    defaultFonts = {
      emoji = ["Noto Color Emoji" "OpenMoji Color"];
    };
  };
}
