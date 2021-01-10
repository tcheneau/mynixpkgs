# Tony Cheneau's custom packages

Disclamer: it probably is not the Nix/NixOS way


Heavily inspired from the following tutorial:
https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/experiment-packaging.html

# Build the packages

```bash
git clone 
nix-build . -A podman_compose
```

# Adding it to your NixOS system

In the */etc/nixos/configuration.nix*:


