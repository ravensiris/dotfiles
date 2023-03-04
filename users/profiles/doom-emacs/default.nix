{ pkgs, unstable, ... }:
{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacs;
    emacsPackagesOverlay = (final: prev: {
      tree-sitter-langs = prev.tree-sitter-langs.overrideAttrs (esuper: rec {
        version = "0.12.15";
        name = (builtins.trace esuper.name "emacs-tree-sitter-langs-${version}");
        src = pkgs.fetchFromGitHub {
          owner = "emacs-tree-sitter";
          repo = "tree-sitter-langs";
          rev = "1076cf2";
          sha256 = "sha256-ULBgre8l6+QKXnvkUKptTlo3JybseYRf6mmfxvHSm/s=";
        };
      });
    });
  };

  home.packages = with pkgs; [ nodePackages.mermaid-cli zip unzip ];
}
