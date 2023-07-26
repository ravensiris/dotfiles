{pkgs, impermanence, ...}: {
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
   ];
	xdg.enable = true;

   home.persistence."/nix/persist/home/q".allowOther = true;

  # home.persistence."/nix/persist/home/q" = {
  #   files = [
  #     ".ssh/id_rsa"
  #     ".ssh/id_rsa.pub"
  #     ".ssh/id_ed25519.pub"
  #     ".ssh/id_ed25519"
  #     ".local/share/nix/trusted-settings.json"
  #     ".local/share/fish/fish_history"
  #   ];
  #   directories = [
  #     ".gnupg"
  #     ".password-store"
  #     ".config/BraveSoftware/Brave-Browser"
  #     ".config/musikcube"
  #     ".local/share/yuzu"
  #     ".mozilla"
  #     ".local/state/wireplumber"
  #   ];
  #   allowOther = true;
  # };

  home.stateVersion = "23.05";
}
