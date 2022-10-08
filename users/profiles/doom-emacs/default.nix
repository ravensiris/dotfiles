{ pkgs, ... }: {
  programs.doom-emacs = {
    enable = false;
    doomPrivateDir = ./doom.d;
    # emacsPackage = pkgs.emacsPgtkNativeComp;
  };
}
