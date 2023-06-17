{
  pkgs,
  impermanence,
  ...
}: {
  users.mutableUsers = false;
  users.users.q = {
    # passwordFile = "/run/agenix/qPassword";
    password = "arstarst";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input"];
  };

  home-manager.users.q = {pkgs, ...}: {
    home.packages = [
      pkgs.neovim
    ];
    imports = [impermanence.nixosModules.home-manager.impermanence];
    home.persistence."/nix/persist/home/q" = {
      files = [
        ".ssh/id_rsa"
        ".ssh/id_rsa.pub"
        ".local/share/nix/trusted-settings.json"
        ".local/share/beets/musiclibrary.db"
        ".config/fish/completions/beet.fish"
        ".local/share/fish/fish_history"
      ];
      directories = [
        ".gnupg"
        ".password-store"
        ".mozilla"
        ".config/BraveSoftware/Brave-Browser"
        ".config/musikcube"
        ".config/Sonixd"
        ".local/share/yuzu"
        ".config/easyeffects"
      ];
      allowOther = true;
    };

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          function fish_greeting
            if [ (tput cols) -ge 40 ]; and [ (tput lines) -ge 18 ]; ${pkgs.nitch}/bin/nitch; end
          end
        '';
        plugins = with pkgs.fishPlugins; [
          {
            name = "pure";
            src = pure.src;
          }
        ];
        shellAliases = {
          "du" = "${pkgs.du-dust}/bin/dust";
          "ls" = "${pkgs.exa}/bin/exa --icons";
          "la" = "${pkgs.exa}/bin/exa --icons -la";
          "cat" = "${pkgs.bat}/bin/bat";
          "df" = "${pkgs.duf}/bin/duf";
          "ps" = "${pkgs.procs}/bin/procs";
          "curl" = "${pkgs.curlie}/bin/curlie";
          "dig" = "${pkgs.dogdns}/bin/dog";
          "cp" = "${pkgs.xcp}/bin/xcp";
        };
      };
    home.stateVersion = "23.05";
  };
}
