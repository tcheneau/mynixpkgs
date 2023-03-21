self: super:

{
   podman_compose = super.python3Packages.callPackage ./pkgs/podman-compose {};
   bandcamp-dl = super.python3Packages.callPackage ./pkgs/bandcamp-dl {};
   pypdfocr = super.python2Packages.callPackage ./pkgs/pypdfocr {};
   zed_free = super.callPackage ./pkgs/zed-free {};
   custombeat = super.callPackage ./pkgs/beat {};
   sysinfo = super.callPackage ./pkgs/sysinfo {};
   gorfplayer = super.callPackage ./pkgs/gorfplayer {};
   openldap24 = super.callPackage ./pkgs/openldap24 {};
   samba4-fix = super.callPackage ./pkgs/samba/4.x.nix {};
   samba4Full-fix = lowPrio (samba4-fix.override {
    enableLDAP = true;
    enablePrinting = true;
    enableMDNS = true;
    enableDomainController = true;
    enableRegedit = true;
    enableCephFS = !stdenv.hostPlatform.isAarch64;
   });
#   imhex = super.callPackage ./pkgs/imhex {};
#   anki = super.python3Packages.callPackage ./pkgs/anki {};
}
