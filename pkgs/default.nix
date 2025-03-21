{pkgs, ...}: let
  callPackage' = path: overrides: let
    f = import path;
  in
    f ((builtins.intersectAttrs (builtins.functionArgs f) pkgs) // overrides);

  sources = callPackage' _sources/generated.nix {};
  callPackage = path: overrides:
    callPackage' path (overrides // {sources = sources;});
in {
  nixpkgs.overlays = [
    (final: prev: {
      khinsider = callPackage ./khinsider {};
      anime4k = callPackage ./anime4k {};
    })
  ];
}
