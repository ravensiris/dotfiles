{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        violentmonkey
        sponsorblock
      ];
      id = 0;
      name = "Default";
    };
    profiles.personal = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        violentmonkey
        sponsorblock
      ];
      id = 1;
      name = "Personal";
    };

    profiles.work = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
      ];
      id = 2;
      name = "Work";
    };
  };
  xdg = {
    desktopEntries = {
      firefox = {
        name = "Firefox";
        genericName = "Web Browser";
        exec = "firefox %U";
        terminal = false;
        categories = ["Application" "Network" "WebBrowser"];
        mimeType = ["text/html" "text/xml"];
        actions = {
          "Work-Profile" = {
            exec = ''${pkgs.firefox}/bin/firefox -P "Work"'';
            name = "Work Profile";
          };
        };
      };
    };
  };

  home.persistence."/nix/persist/home/q".directories = [".mozilla"];
}
