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
    enable = true;
    settings = {
      directory = "~/Music";
      library = "~/.local/share/beets/musiclibrary.db";
      "import" = {
        move = false;
        copy = true;
      };
      scrub = {auto = true;};
      fetchart = {
        high_resolution = true;
      };
      badfiles = {
        check_on_import = true;
        commands = {
          flac = "${pkgs.flac}/bin/flac --silent --test";
          mp3 = "${pkgs.mp3val}/bin/mp3val -si";
        };
      };
      paths = {
        default = "$albumartist/$album%aunique{}/%if{$multidisc,Disc $disc/}$track $title";
      };
      item_fields = {
        multidisc = "1 if disctotal > 1 else 0";
      };
      plugins = lib.concatStringsSep " " ["inline" "embedart" "fetchart" "badfiles" "fish" "duplicates" "scrub"];
    };
  };
}
