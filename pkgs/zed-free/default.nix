{ stdenv, lib, fetchurl, makeWrapper
, dpkg, patchelf
, gtk2, glib, gdk-pixbuf, alsaLib, nss, nspr, cups, libgcrypt, dbus, systemd
, libXdamage, expat
, qt5, libxml2, libxslt, openldap24, vim }:

let
#  inherit (stdenv) lib;
  LD_LIBRARY_PATH = lib.makeLibraryPath
    [ glib gtk2 gdk-pixbuf alsaLib nss nspr cups libgcrypt qt5.qtbase libxml2 libxslt openldap24 dbus libXdamage expat ];
in
stdenv.mkDerivation rec {
  version = "2022.2";
  pname = "zed-free";

  src =
    # nix-hash --type sha256 --flat --base32
    if stdenv.hostPlatform.system == "i686-linux" then fetchurl {
      url = "https://www.zedencrypt.com/file/get/-/item_key/13802-21-0a970608";
      sha256 = "0ri2x922f63w2zpw978h182prq1ksymv2bkicnd8f69i62q266rw";
    } else fetchurl {
      url = "https://www.zedencrypt.com/file/get/-/item_key/13802-22-1d9a6a64";
      sha256 = "0vi73z9nsbrq8jkgm7a83mr1ibikp33ymmm8vdgi9p0f9qckv96h";
    };

  nativeBuildInputs = [ makeWrapper dpkg ];
  
  ld_preload = ./fakesyscalls.c;
  prepare_primx = ./prepare-primx.sh;

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv usr/bin/zed_free $out/bin

    cp ${prepare_primx} $out/bin/$(basename ${prepare_primx})
    chmod 755 $out/bin/$(basename ${prepare_primx})

    mkdir -p $out/share
    mv usr/share/* $out/share
    
    mkdir -p $out/lib
    ln -s ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/
    #    ln -s ${lib.getLib systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    # allow changes in hardcoded path
    gcc -fPIC -shared -o fakesyscalls.so $ld_preload -ldl -D_GNU_SOURCE -D_LARGEFILE_SOURCE=1
    mv fakesyscalls.so $out/lib/

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/zed_free

    wrapProgram $out/bin/zed_free \
       --run $out/bin/$(basename ${prepare_primx}) \
       --prefix LD_PRELOAD : $out/lib/fakesyscalls.so \
       --prefix NIX_ZED_USR_PREFIX : $out/share/ \
       --prefix NIX_ZED_ETC_PREFIX : /tmp/primx/ \
       --prefix LD_LIBRARY_PATH : $out/lib:${LD_LIBRARY_PATH} \
       --prefix QT_PLUGIN_PATH : ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix} \
       --prefix QT_DEBUG_PLUGINS : 1
       #--prefix LD_DEBUG : bindings \
       #--prefix LD_DEBUG : bindings,symbols \

#
#    for binary in StarUML Brackets-node; do
#      ${patchelf}/bin/patchelf \
#        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
#        $out/bin/$binary
#      wrapProgram $out/bin/$binary \
#        --prefix LD_LIBRARY_PATH : $out/lib:${LD_LIBRARY_PATH}
#    done
  '';

  meta = with lib; {
    description = "To encrypt personnal and sensitive data";
    homepage = "https://www.zedencrypt.com/";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
