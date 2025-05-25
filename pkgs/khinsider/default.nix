{
  sources,
  stdenv,
  lib,
  fetchFromGitHub,
  pkgs,
}:
with pkgs.python3Packages;
  buildPythonPackage rec {
    inherit (sources.khinsider) src pname version;
    format = "setuptools";
    propagatedBuildInputs = [beautifulsoup4 requests];

    preBuild = ''
      cat >setup.py <<'EOF'
      from setuptools import setup
      requires = ["requests (>= 2.0.0, < 3.0.0)", "beautifulsoup4 (>= 4.4.0, < 5.0.0)"]
      setup(
        name="khinsider",
        description="A script for khinsider mass downloads. Get video game soundtracks quickly and easily! Also a Python interface.",
        author="obskyr",
        version="0.1.0",
        url="https://github.com/obskyr/khinsider/",
        py_modules=["khinsider"],
        scripts=["khinsider.py"],
        install_requires=requires,
        requires=requires
      )
      EOF
    '';

    postInstall = ''
      mv $out/bin/khinsider.py $out/bin/khinsider;
    '';

    meta = with lib; {
      homepage = "https://github.com/obskyr/khinsider/";
      description = "A script for khinsider mass downloads. Get video game soundtracks quickly and easily! Also a Python interface.";
    };
  }
