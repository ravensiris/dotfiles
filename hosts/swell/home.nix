{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    devenv
    (pkgs.nerdfonts.override {fonts = ["VictorMono"];})
  ];

  imports = [
    ../../users/q/neovim
    ../../users/q/git.nix
    ../../users/q/direnv.nix
    ../../users/q/firefox.nix
    ../../users/q/fish.nix
    ../../users/q/kitty.nix
  ];
  neovim.impermanence = false;
  firefox.impermanence = false;
  fish.impermanence = false;
  kitty.nixGL = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";

  programs.home-manager.enable = true;
  home.username = "q";
  home.homeDirectory = "/home/q";
  home.stateVersion = "23.11";
}
