{ lib, gcc12Stdenv, fetchgit, substituteAll, cmake, pkg-config, imgui, libGL, glfw, dbus, freetype, mbedtls, python3, file, gtk3, gsettings-desktop-schemas, makeWrapper }:

gcc12Stdenv.mkDerivation rec {
  pname = "ImHex";
  version = "1.19.3";

  src = fetchgit {
      url = "https://github.com/WerWolv/ImHex";
      sha256 = "sha256-SFv5ulyjm5Yf+3Gpx+A74so2YClCJx1sx0LE5fh5eG4=";
      rev = "54b31b8a556092b219dfa7b7a6ccea72f454b1d0";
      fetchSubmodules = true;
    };

  src_imhex_patterns = fetchgit {
      url = "https://github.com/WerWolv/ImHex-Patterns";
      sha256 = "sha256-PSuihZldT7oZJM6YWpb+70B6ywuJagXlbNKp5yDDtJk=";
      rev = "9e4a1d1d9645c543bd16f2b8a39780bf4080b33a";
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
