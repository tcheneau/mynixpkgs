self: super:

{
   podman_compose = super.python3Packages.callPackage ./pkgs/podman-compose {};
   pypdfocr = super.python2Packages.callPackage ./pkgs/pypdfocr {};
   zed_free = super.callPackage ./pkgs/zed-free {};
   custombeat = super.callPackage ./pkgs/beat {};
   sysinfo = super.callPackage ./pkgs/sysinfo {};
}
