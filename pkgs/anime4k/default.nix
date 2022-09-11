{ sources, stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  inherit (sources.anime4k) src pname version;
  installPhase = ''
    find ./glsl/ -type f -iname '*.glsl' -exec install -Dm 644 {} -t $out/usr/share/shaders/ \;
  '';

  meta = with lib; {
    description = "A High-Quality Real Time Upscaler for Anime Video";
    homepage = "https://bloc97.github.io/Anime4K/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
