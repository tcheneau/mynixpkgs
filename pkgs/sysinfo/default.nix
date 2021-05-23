{
  fetchurl,
  stdenv,
  pkgs
}:
pkgs.stdenv.mkDerivation rec {
  pname = "sysinfo";
  version = "0.0.1";

  # nothing to unpack!
  dontUnpack = true;


  sysinfod = fetchurl {
    url = "http://192.168.1.35:9000/drone/sysinfo/arm64/sysinfod";
    sha256 = "0fnw4pjzczv01a0gsscwjv67awfn70djpm6q1ycjg3wy3jbkaxi8";
  };

  sysinfoc = fetchurl {
    url = "http://192.168.1.35:9000/drone/sysinfo/arm64/sysinfoc";
    sha256 = "0zfcq3rd8nkf9b6rcgj4s0pjqsqwsjpvxjx6rwnlgw512kw1f2yn";
  };

  netc = fetchurl {
    url = "http://192.168.1.35:9000/drone/sysinfo/arm64/netc";
    sha256 = "13mv5k0ilz8axgq9syfmz9aaj2xg3mr62g3xcjbhwc5rxj3bbb4d";
  };

  timec = fetchurl {
    url = "http://192.168.1.35:9000/drone/sysinfo/arm64/timec";
    sha256 = "14q0c0iy4dc9wk0fjn8n9s2d0qv4giwppc43lkf935ky7labfvwp";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${sysinfod} $out/bin/sysinfod
    cp ${sysinfoc} $out/bin/sysinfoc
    cp ${netc} $out/bin/netc
    cp ${timec} $out/bin/timec
    chmod 555 $out/bin/*
  '';

  meta = with stdenv.lib; {
    description = "system information on a LCD";
    homepage = "http://192.168.1.35:3000/tony/system-info/";
    license = licenses.unfree;
    platforms = [ "arm64-linux" ];
  };
}