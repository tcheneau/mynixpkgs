# Tony Cheneau's custom packages

Disclamer: it probably is not the Nix/NixOS way


Heavily inspired from the following tutorial:
https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/experiment-packaging.html

# Build the packages

```bash
git clone 
nix-build . -A environment.systemPackages
```

# Adding it to your NixOS system

In the */etc/nixos/configuration.nix*:

```nix

{ lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (fetchGit { url = "https://github.com/tcheneau/mynixpkgs"; ref = "beb9022756b47162fb5254370194b0febc5f0543"; } + "/default.nix")
    ];
  :
```

Here, change the ref to the hash of the git commmit you are interested in. This will install all my custom packages.

