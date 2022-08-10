{ lib, gcc12Stdenv, fetchgit, substituteAll, cmake, pkg-config, imgui, libGL, glfw, dbus, freetype, mbedtls, python3, file, gtk3, gsettings-desktop-schemas, makeWrapper }:

gcc12Stdenv.mkDerivation rec {
  pname = "ImHex";
  version = "1.20.0";

  src = fetchgit {
      url = "https://github.com/WerWolv/ImHex";
      sha256 = "sha256-GFLjiuMVQqSggehcOCn9W/yCfFWC22u71Oo7SpMsieo=";
      rev = "f86dffb2f02adc70eb9cc0ff5a214dbae5700aa6";
      fetchSubmodules = true;
    };

  src_imhex_patterns = fetchgit {
      url = "https://github.com/WerWolv/ImHex-Patterns";
      sha256 = "sha256-2goywWTdR0Dz0RaxwpEuPHIazp1VD6rhluTGZwIJ5VA=";
      rev = "65f2b7821bc84398671dc3f34d36b093b15c21ae";
    };

  nativeBuildInputs = [ cmake pkg-config python3 gtk3 makeWrapper ];
  buildInputs = [ imgui freetype libGL glfw dbus mbedtls file gsettings-desktop-schemas ];

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./no-imhex-patterns-dep.patch;
      imhex_patterns_src = src_imhex_patterns;
    })
    ./no-xdg.portal.patch
  ];
  
  postInstall = ''
    wrapProgram $out/bin/imhex \
                  --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
                  --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
  '';

  meta = with lib; {
    description = "A Hex Editor for Reverse Engineers, Programmers and people who value their retinas when working at 3 AM.";
    homepage = "https://github.com/WerWolv/ImHex";
    license = licenses.gpl2;
    maintainers = [ "Tony Cheneau <tony.cheneau@amnesiak.org>" ];
    platforms = platforms.linux;
  };
}
