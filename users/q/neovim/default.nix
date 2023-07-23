{...}: {
  xdg = {
    enable = true;
    configFile."nvim" = {
      source = ./neovim;
      recursive = true;
    };
  };

  home.pacakges = with pkgs; [
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
  ];

  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".local/share/nvim"
    ];
  };
}
