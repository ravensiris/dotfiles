{
  lib,
  pkgs,
  config,
  ...
}: {
  options.neovim.impermanence = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = {
    xdg = {
      enable = true;
      configFile."nvim" = {
        source = ./neovim;
        recursive = true;
      };
    };
    home =
      {
        packages = with pkgs; [
          neovim
          alejandra
          black
          ruff
          isort
          mypy
          ripgrep
          stylua
          lua-language-server
          gnumake
          gcc
          elixir-ls
        ];
        sessionVariables = {EDITOR = "nvim";};
      }
      // lib.optionalAttrs config.neovim.impermanence {
        persistence."/nix/persist/home/q" = {
          directories = [
            ".local/share/nvim"
            ".cache/nvim"
          ];
        };
      };
  };
}
