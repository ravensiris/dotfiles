{
  lib,
  pkgs,
  config,
  ...
}: let
  protols = pkgs.rustPlatform.buildRustPackage rec {
    pname = "protols";
    version = "0.7.0";

    src = pkgs.fetchFromGitHub {
      owner = "coder3101";
      repo = pname;
      rev = version;
      hash = "sha256-yK0KgwHR+nXJu1TLXMhrpXR/4gFM7JVSqjtkUinESSE=";
    };
    cargoHash = "sha256-2Cxf9r3SaMlOyr0TSczigtK1ZSNEzeaNzbzYMhCEc4M=";
    doCheck = false;
  };
in {
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
    ];
    sessionVariables = {EDITOR = "nvim";};
  };
  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".local/share/nvim"
    ];
  };
}
