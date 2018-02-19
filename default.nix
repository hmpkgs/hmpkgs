{ config, pkgs, lib, ...}: {
  imports = [
    ./lib/app-support.nix
    ./amethyst
    ./docker
    ./hammerspoon
    ./iterm2
    ./licecap
    ./org-build
    ./org-export
    ./spotify
    ./textual
    ./viscosity
  ];
}

