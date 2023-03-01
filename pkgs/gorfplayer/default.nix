{
  fetchurl,
  stdenv,
  pkgs,
  patchelf,
  lib
}:
pkgs.stdenv.mkDerivation rec {
  pname = "gorfplayer";
  version = "0.0.1";

  # nothing to unpack!
  dontUnpack = true;


  gorfplayer = fetchurl {
    url = "http://192.168.1.35:9000/drone/gorfplayer/arm64/gorfplayer";
    sha256 = "1zigj3gxqxa28fs356i5swnsbs6qra9qhhcacdmd8ai9ainl3zdr";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${gorfplayer} $out/bin/gorfplayer
    chmod 755 $out/bin/*
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/gorfplayer
  '';

  meta = with lib; {
    description = "system information on a LCD";
    homepage = "https://github.com/tcheneau/gorfplayer";
    license = licenses.bsd3;;
    platforms = [ "aarch64-linux" ];
  };
}
