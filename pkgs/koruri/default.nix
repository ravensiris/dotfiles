{ lib, fetchzip, stdenv }:

stdenv.mkDerivation rec{
  version = "20210720";
  pname = "koruri";

  src = fetchzip {
    url = "https://github.com/Koruri/Koruri/releases/download/${version}/Koruri-${version}.tar.xz";
    sha256 = "sha256-9m0rRNbMEMZELo+UR8LqFaiVG3CCEBaNO6mq5san1AA=";
    extension = "tar";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts/koruri
    install -m555 $src/*.ttf $out/share/fonts/koruri
  '';
}
