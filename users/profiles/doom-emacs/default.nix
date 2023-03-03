{ pkgs, config, ... }: {

  home.packages = with pkgs; [ nodePackages.mermaid-cli zip unzip emacsPgtk ];
  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".emacs.d"
      ".doom.d"
    ];
    allowOther = true;
  };

  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "doom-config/config.el".source = ./config.el;
      "doom-config/init.el".source = ./init.el;
      "doom-config/packages.el".source = ./packages.el;
      "emacs" = {
        source = builtins.fetchGit "https://github.com/hlissner/doom-emacs";
        onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync -u
          fi
        ''}";
      };
    };
  };
}
