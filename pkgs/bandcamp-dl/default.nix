{ stdenv, buildPythonApplication, python39Packages, lib, fetchgit, python3 }:

buildPythonApplication rec {
  name = "bandcamp-dl";
  pname = "bandcamp-dl";
  version = "0.0.10";

  src = fetchgit {
    url = "https://github.com/iheanyi/bandcamp-dl";
    rev = "4a33f4a4056139b4c2c88148d1fc043a7e2f3e8c";
    sha256 = "0y36xj0v7si3bv8di019n6bvmzhsx5vm5sbgf02c8pikrj2m0cqj";
  };

  doCheck = false;

  propagatedBuildInputs = [
    python39Packages.demjson
    python39Packages.beautifulsoup4
    python39Packages.docopt
    python39Packages.mutagen
    python39Packages.requests
    python39Packages.unicode-slugify
    python39Packages.mock
    python39Packages.chardet
  ];

  meta = with lib; {
    homepage = "https://github.com/iheanyi/bandcamp-dl";
    description = "Simple python script to download Bandcamp albums";
    license = licenses.publicDomain;
  };

}
