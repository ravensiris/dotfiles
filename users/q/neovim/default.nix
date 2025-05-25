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
      nil
      nodePackages_latest.typescript-language-server
      # unstable.tailwindcss-language-server
      tailwindcss-language-server
      vscode-langservers-extracted
      minijinja
      protols
      lldb
      unstable.eslint_d
      unstable.prettierd
      unstable.markdownlint-cli
    ];
    sessionVariables = {EDITOR = "nvim";};
  };
  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".local/share/nvim"
    ];
  };
}
