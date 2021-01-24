{ stdenv, lib, fetchurl, makeWrapper
, dpkg, patchelf
, gtk2, glib, gdk-pixbuf, alsaLib, nss, nspr, cups, libgcrypt, dbus, systemd
, libXdamage, expat
, qt5, libxml2, libxslt, openldap }:

let
  inherit (stdenv) lib;
  LD_LIBRARY_PATH = lib.makeLibraryPath
    [ glib gtk2 gdk-pixbuf alsaLib nss nspr cups libgcrypt qt5.qtbase libxml2 libxslt openldap dbus libXdamage expat ];
in
stdenv.mkDerivation rec {
  version = "2020.4";
  pname = "zed-free";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then fetchurl {
      url = "https://www.zedencrypt.com/file/get/-/item_key/13802-21-57cde2c4";
      sha256 = "0hv1x2lhdmrwzckqiz0lrg95mb49f9099mgwp5f7zjp5kb4llyxs";
    } else fetchurl {
      url = "https://www.zedencrypt.com/file/get/-/item_key/13802-22-7036b18e";
      sha256 = "16gql2a9ld8p6b28pw4ix2jg0ikhpx96nin8w6cvd026cr23x2ng";
    };

  nativeBuildInputs = [ makeWrapper dpkg ];
  
  ld_preload = ./fakesyscalls.c;

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv usr/bin/zed_free $out/bin

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

  meta = with stdenv.lib; {
    description = "To encrypt personnal and sensitive data";
    homepage = "https://www.zedencrypt.com/";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
