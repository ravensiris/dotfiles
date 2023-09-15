{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "anime4k";
  version = "78e4f78f65b772e94bae6e7db5c49af1e889f784";
  src = fetchFromGitHub {
    owner = "bloc97";
    repo = "Anime4K";
    rev = "78e4f78f65b772e94bae6e7db5c49af1e889f784";
    fetchSubmodules = false;
    sha256 = "sha256-dKFVNd3DtZ1AbJodoa82FfKhBJu39RMrI5e0To+vqwU=";
  };
  installPhase = ''
    find ./glsl/ -type f -iname '*.glsl' -exec install -Dm 644 {} -t $out/usr/share/shaders/ \;
  '';

  meta = with lib; {
    description = "A High-Quality Real Time Upscaler for Anime Video";
    homepage = "https://bloc97.github.io/Anime4K/";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
