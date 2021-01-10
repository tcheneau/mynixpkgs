{ stdenv, buildPythonApplication, pythonPackages, lib, fetchgit, python3 }:

buildPythonApplication rec {
  name = "podman_compose";
  pname = "podman-compose";
  version = "0.1.5";

  src = fetchgit {
    url = "https://github.com/containers/podman-compose";
    rev = "6289d25a42cfdb5dfcac863b1b1b4ace32ce31b7";
    sha256 = "1v72hl0kj6r0aq21z22y9bm6n7hh48s6xrd6y1rjk9cwnxs4vz8n";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pythonPackages.pyyaml
  ];

  meta = with lib; {
    homepage = "https://github.com/containers/podman-compose";
    description = "Like docker compose, for podman";
    license = licenses.gpl2;
  };

}
