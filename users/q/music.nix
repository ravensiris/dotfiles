{pkgs, ...}: {
  home.packages = with pkgs; [musikcube];
  home.persistence."/nix/persist/home/q" = {
    files = [
      ".config/fish/completions/beet.fish"
    ];

    directories = [
      ".local/state/wireplumber"
      ".config/easyeffects"
      ".config/musikcube"
    ];
  };

  services.easyeffects = {
    enable = true;
    preset = "HD800S";
  };
}
