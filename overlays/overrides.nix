channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    cachix
    dhall
    discord
    element-desktop
    rage
    nix-index
    nixpkgs-fmt
    qutebrowser
    signal-desktop
    starship
    deploy-rs
    ;

  haskellPackages = prev.haskellPackages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { })) (hfinal: hprev:
        let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
        in
        {
          # same for haskell packages, matching ghc versions
          inherit (channels.latest.haskell.packages."ghc${version}")
            haskell-language-server;
        });
    });

  tree-sitter = prev.tree-sitter.overrideAttrs (old: rec {
    version = "0.19.5";
    src = prev.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "8d86905";
      sha256 = "sha256-tq66J0+2rS94s73vtCbk/C7EbtL9yMFGNvsjobYGq+I=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (_: {
      inherit src version;
      outputHash = "sha256-jjSlxqgfmlDOK3lsUaF0bTst6XkN1wq5x4vYPQWhnkc=";
    });
  });
}
