{ config, pkgs, lib, ...}: {
  imports = [
    ./lib/app-support.nix
    ./amethyst
    ./docker
    ./hammerspoon
    ./org-build
    ./org-export
    ./viscosity
  ];
}

