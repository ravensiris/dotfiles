final: prev: rec{
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  anime4k = final.callPackage (import ./anime4k) { };
  elixir_1_14_elixir_ls_0_12_0 = final.callPackage (import ./elixir_1_14_elixir_ls_0_12_0) { };
  # then, call packages with `final.callPackage`
}
