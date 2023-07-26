{
  pkgs,
  impermanence,
  ...
}: {
  home.packages = with pkgs; [
    htop
  ];
  imports = [
    impermanence.nixosModules.home-manager.impermanence
    ./neovim
    ./sway.nix
    ./firefox.nix
    ./fish.nix
    ./kitty.nix
    ./gpg.nix
    ./git.nix
    ./direnv.nix
    ./ssh.nix
    ./music.nix
  ];
  xdg.enable = true;
  home.persistence."/nix/persist/home/q".allowOther = true;

  home.stateVersion = "23.05";
}
