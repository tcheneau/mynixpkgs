self: super:

{
   podman_compose = super.python3Packages.callPackage ./pkgs/podman-compose {};
   bandcamp-dl = super.python3Packages.callPackage ./pkgs/bandcamp-dl {};
   pypdfocr = super.python2Packages.callPackage ./pkgs/pypdfocr {};
   zed_free = super.callPackage ./pkgs/zed-free {};
   custombeat = super.callPackage ./pkgs/beat {};
   sysinfo = super.callPackage ./pkgs/sysinfo {};
   openldap24 = super.callPackage ./pkgs/openldap24 {};
   imhex = super.callPackage ./pkgs/imhex {};
}
