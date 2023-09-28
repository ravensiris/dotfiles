{
  pkgs,
  impermanence,
  ...
}: {
  home.packages = with pkgs; [
    htop
    qbittorrent
    mpv
    imv
    p7zip
    gimp
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

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  xdg.enable = true;
  home.persistence."/nix/persist/home/q".allowOther = true;

  home.stateVersion = "23.05";
}
