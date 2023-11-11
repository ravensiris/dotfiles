{pkgs, ...}: {
  packages = [
    pkgs.git
    (pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" {})
    pkgs.nvfetcher
  ];
}
