{ lib
, buildGoModule
, fetchFromGitHub
}:
let
  version = "0.4.0";
in
buildGoModule {
  pname = "golang-dnstap";
  inherit version;

  src = fetchFromGitHub {
    owner = "dnstap";
    repo = "golang-dnstap";
    rev = "v${version}";
    hash = "sha256-GmwHJ6AQ4HcPEFNeodKqJe/mYE1Fa95hRiQWoka/nv4=";
  };

  vendorHash = "sha256-xDui88YgLqIETIR34ZdqT6Iz12v+Rdf6BssAIXgaMLU=";

  subPackages = [ "dnstap" ];

  ldflags = [
    "-s" "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/dnstap/golang-dnstap";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = licenses.asl20;
    mainProgram = "golang-dnstap";
    maintainers = [ "Tony Cheneau <tony.cheneau@amnesiak.org>" ]; 
  };
}
