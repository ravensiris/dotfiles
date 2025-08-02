{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
  ];

  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".local/share/PrismLauncher"
      ".config/PrismLauncher"
    ];
  };
}
