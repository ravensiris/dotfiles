{ pkgs, ... }: {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsPgtk;
  };

  home.packages = with pkgs; [nodePackages.mermaid-cli zip unzip];
}
