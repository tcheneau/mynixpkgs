{
  fetchurl,
  stdenv,
  pkgs,
  patchelf,
  lib
}:
pkgs.stdenv.mkDerivation rec {
  pname = "sysinfo";
  version = "0.0.1";

  # nothing to unpack!
  dontUnpack = true;


  sysinfod = fetchurl {
    url = "http://192.168.1.35:9000/drone/sysinfo/arm64/sysinfod";
    sha256 = "107ch75nggcmi287z36r7kdj5ygcbryxaw4dgj0bnsa97jmnzmm2";
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
    sha256 = "10pg5lg37z25cjdppdbc77dhx8wwqk2c5aki5r47h86vgczr8ixx";
  };

  binancec = fetchurl {
    url = "http://192.168.1.35:9000/drone/sysinfo/arm64/binancec";
    sha256 = "073bwnjljsdc0kgllglcvqh7xa0jgm2zfqz3lld5fd34mkai32q6";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${sysinfod} $out/bin/sysinfod
    cp ${sysinfoc} $out/bin/sysinfoc
    cp ${netc} $out/bin/netc
    cp ${timec} $out/bin/timec
    cp ${binancec} $out/bin/binancec
    chmod 755 $out/bin/*
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/sysinfod
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/sysinfoc
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/netc
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/timec
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/binancec
  '';

  meta = with lib; {
    description = "system information on a LCD";
    homepage = "http://192.168.1.35:3000/tony/system-info/";
    license = licenses.unfree;
    platforms = [ "aarch64-linux" ];
  };
}
