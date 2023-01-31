final: prev: rec{
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  anime4k = final.callPackage (import ./anime4k) { };
  khinsider = final.callPackage (import ./khinsider) {};
}
