# Tony Cheneau's custom packages

Disclamer: it probably is not the Nix/NixOS way


Heavily inspired from the following tutorials/blogs:

- https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/experiment-packaging.html
- https://github.com/mrVanDalo/nix-overlay

# Using nix-shell from a user profile

All that is needed it to declare the overlay

```bash
# run from the root of this repository
mkdir -p ~/.config/nixpkgs/overlays
ln -s $PWD ~/.config/nixpkgs/overlays/mynixpkgs
```

Then you can run nix-shell with the overlay packages:

```bash
nix-shell -p podman_compose
```

# Manual build

Go to the package directory and run the command that is at the *default.nix*
file in the root of this repository. For example, in order to build
*podman_compose*:

```bash
cd pkgs/podman_compose
nix-build -E 'with import <nixpkgs> {} ; python3Packages.callPackage ./default.nix {}'
```

# Adding this overlay to your NixOS system

In the */etc/nixos/configuration.nix*:

```nix

...

{
  # replace the ref with the reference you want to pull!
  nixpkgs.config.packageOverrides = {
    import (fetchGit { url = "https://github.com/tcheneau/mynixpkgs"; ref = "8f4d3265a37fb4d3eb7409829a4d9c5006c707da"; } + "/default.nix") pkgs
  }

  environment.systemPackages = [

    ...

    pkgs.podman_compose

    ...
  ];


  ...

```

Here, change the ref to the hash of the git commmit you are interested in. This will install all my custom packages.

# Side note

I am amazed at how HARD it was to actually get down to these few instructions.
