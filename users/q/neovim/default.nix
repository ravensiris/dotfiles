{pkgs, ...}: {
  xdg = {
    enable = true;
    configFile."nvim" = {
      source = ./neovim;
      recursive = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    alejandra
    black
    ruff
    isort
    mypy
    ripgrep
    stylua
    lua-language-server
    nodePackages_latest.prettier
    nodePackages_latest.vscode-langservers-extracted
    nur.repos.bandithedoge.nodePackages.emmet-language-server
    gnumake
    gcc
  ];

  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".local/share/nvim"
    ];
  };
}
