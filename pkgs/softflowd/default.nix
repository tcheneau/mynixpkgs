{ lib
, stdenv
, fetchurl
, autoreconfHook
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "softflowd";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/irino/softflowd/archive/refs/tags/softflowd-v${version}.tar.gz";
    sha256 = "sha256-aNNqIYldCxVbJ8cYxLecwwSk3pLVkdc4h8z9dPkPT/w=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libpcap ];


  meta = with lib; {
    description = "a NetFlow data exporter";
    longDescription = ''
      softflowd: A flow-based network traffic analyser capable of Cisco NetFlow data export software.
    '';
    homepage = "https://github.com/irino/softflowd";
    license = licenses.bsd3;
    maintainers = [ "Tony Cheneau <tony.cheneau@amnesiak.org>" ];
    platforms = platforms.linux;
  };
}
