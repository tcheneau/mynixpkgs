{ stdenv, buildPythonApplication, pythonPackages, lib, fetchgit, python3 }:

buildPythonApplication rec {
  name = "podman_compose";
  pname = "podman-compose";
  version = "1.0.3";

  src = fetchgit {
    url = "https://github.com/containers/podman-compose";
    rev = "24ec539932580a6bc96d6eb2341141b6d7198b39";
    # nix-prefetch-url --unpack https://github.com/containers/podman-compose/archive/refs/tags/v1.0.3.tar.gz
    sha256 = "1yv5ki55j43l0s7rqgiywglghy2dkdsvylzqly8slvkxvkhwwbsa";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pythonPackages.pyyaml
    pythonPackages.python-dotenv
  ];

  meta = with lib; {
    homepage = "https://github.com/containers/podman-compose";
    description = "Like docker compose, for podman";
    license = licenses.gpl2;
  };

}
