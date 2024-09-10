{
  lib,
  pkgs,
  config,
  ...
}: {
  xdg = {
    enable = true;
    configFile."nvim" = {
      source = ./neovim;
      recursive = true;
    };
  };
  home = {
    packages = with pkgs; [
      unstable.neovim
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
  };
  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".local/share/nvim"
      ".cache/nvim"
    ];
  };
}
