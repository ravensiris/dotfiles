{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [musikcube];
  home.persistence."/nix/persist/home/q" = {
    files = [
      ".local/share/beets/musiclibrary.db"
      ".config/fish/completions/beet.fish"
    ];

    directories = [
      ".local/state/wireplumber"
      ".config/easyeffects"
      ".config/musikcube"
    ];
  };

  programs.beets = {
    enable = false;
    package = pkgs.beets.override {};
    settings = {
      directory = "~/Music";
      library = "~/.local/share/beets/musiclibrary.db";
      "import" = {
        move = false;
        copy = true;
      };
      fetchart = {
        high_resolution = true;
        sources = [
          "filesystem"
          "albumart"
          "coverart"
          "itunes"
          "amazon"
        ];

        minwidth = 800;
        enforce_ratio = "0.5%";
      };
      badfiles = {
        check_on_import = true;
        commands = {
          flac = "${pkgs.flac}/bin/flac --silent --test";
          mp3 = "${pkgs.mp3val}/bin/mp3val -si";
        };
      };
      plugins = lib.concatStringsSep " " ["embedart" "fetchart" "badfiles" "fish" "duplicates"];
    };
  };
}
