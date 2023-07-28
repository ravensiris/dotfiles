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
    gnumake
    gcc
  ];

  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".local/share/nvim"
    ];
  };
}
