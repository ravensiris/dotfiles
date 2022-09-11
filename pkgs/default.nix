final: prev: rec{
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  anime4k = final.callPackage (import ./anime4k) { };
  # then, call packages with `final.callPackage`
}
