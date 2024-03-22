{
  pkgs,
  fetchTarball,
  ...
}: {
  packages = [
    pkgs.git
    # pkgs.agenix
    # (pkgs.callPackage "${fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" {})
    pkgs.nvfetcher
  ];
}
