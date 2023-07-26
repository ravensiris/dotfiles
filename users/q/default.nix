{pkgs, impermanence, ...}: {
   home.packages = with pkgs; [
     pinentry-gnome
     htop
     pass
   ];
   imports = [
	impermanence.nixosModules.home-manager.impermanence
	./neovim
	./sway.nix
	./firefox.nix
	./fish.nix
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

  # programs.kitty = {
  #   enable = true;
  #   font = {
  #     name = "VictorMono NerdFont";
  #     size = 18;
  #   };
  #   settings = {
  #     shell = "${pkgs.fish}/bin/fish";
  #     confirm_os_window_close = 0;
  #   };
  #   theme = "Dracula";
  #   extraConfig = builtins.concatStringsSep "\n" [
  #     "background_opacity 0.9"
  #   ];
  # };

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  #   config = {
  #     whitelist = {
  #   	prefix = [
  #   	  "/home/q/Projects"
  #   	];
  #     };
  #   };
  # };


  # programs.git = {
  #   enable = true;
  #   signing = {
  #     signByDefault = true;
  #     key = null;
  #   };
  #   userEmail = "maksymilian.jodlowski@gmail.com";
  #   userName = "Maksymilian Jodłowski";
  # };

  # programs.gpg.enable = true;

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = ''
  #     function fish_greeting
  #   	if [ (tput cols) -ge 40 ]; and [ (tput lines) -ge 18 ]; ${pkgs.nitch}/bin/nitch; end
  #     end
  #   '';
  #   plugins = with pkgs.fishPlugins; [
  #     {
  #   	name = "pure";
  #   	src = pure.src;
  #     }
  #   ];
  #   shellAliases = {
  #     "du" = "${pkgs.du-dust}/bin/dust";
  #     "ls" = "${pkgs.exa}/bin/exa --icons";
  #     "la" = "${pkgs.exa}/bin/exa --icons -la";
  #     "cat" = "${pkgs.bat}/bin/bat";
  #     "df" = "${pkgs.duf}/bin/duf";
  #     "ps" = "${pkgs.procs}/bin/procs";
  #     "curl" = "${pkgs.curlie}/bin/curlie";
  #     "dig" = "${pkgs.dogdns}/bin/dog";
  #     "cp" = "${pkgs.xcp}/bin/xcp";
  #   };
  # };

  home.stateVersion = "23.05";
}
