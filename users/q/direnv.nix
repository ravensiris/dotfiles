{...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      whitelist = {
        prefix = [
          "/home/q/Projects"
        ];
      };
    };
  };
}
