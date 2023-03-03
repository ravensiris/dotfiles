{ config, lib, pkgs, ... }:
let
  nvim-ayu = pkgs.vimUtils.buildVimPluginFrom2Nix {
    version = "2023.03.03";
    pname = "neovim-ayu";
    src = pkgs.fetchFromGitHub {
      owner = "Shatur";
      repo = "neovim-ayu";
      rev = "0eb91afe11f1763a477655965684269a545012e1";
      sha256 = "sha256-SQzGMbTmmRWsQhGzx7sGxfyEpQ6QGJcxkEJkiqj3Cto=";
    };
    meta.homepage = "https://github.com/Shatur/neovim-ayu";
  };
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = (nvim-treesitter.withPlugins (
          plugins: pkgs.tree-sitter.allGrammars
        ));
        type = "lua";
        config = builtins.readFile (./tree_sitter.lua);
      }
      vim-nix
      vim-elixir
    ] ++ [
      {
        plugin = nvim-ayu;
        type = "lua";
        config = ''

        '';
      }
    ];
  };
}
