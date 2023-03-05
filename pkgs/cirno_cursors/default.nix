{ lib, stdenvNoCC, unzip }:

stdenvNoCC.mkDerivation rec {
  pname = "cirno-cursor-theme";
  version = "1.0";

  src = ./cirno_cursors.zip;

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    mv index.theme cursor.theme
  '';

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' . $out/share/icons/Cirno-cursors
  '';

  meta = with lib; {
    description = "Cirno cursor theme";
    homepage = "https://www.pixiv.net/en/artworks/13703007";
    platforms = platforms.all;
    maintainers = with maintainers; [ offline ];
  };
}
