final: prev: {
  pubs = prev.pubs.overrideAttrs (o: rec{
    # inherit (prev.sources.manix) pname version src;
    buildInputs = o.buildInputs or [] ++ [ prev.pkgs.makeWrapper ];
    postInstall = o.postInstall or "" + ''
      wrapProgram $out/bin/pubs\
        --add-flags "--config ~/.config/pubsrc"
    '';
  });
}
