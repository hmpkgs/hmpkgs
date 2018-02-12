{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.docker;

  package = pkgs.hmpkgs.installApplication rec {
    name = "Docker";
    version = "17.12.0-ce-mac49";
    src = pkgs.fetchurl {
      url = https://download.docker.com/mac/stable/Docker.dmg;
      sha256 = "0dvr3mlvrwfc9ab6dyx351vraqx01lzxgz8vrczs0vhm2rpv3kdy";
    };
    sourceRoot = "Docker.app";
    description = "Docker for OSX";
    homepage = "";
  };

in {
  options = {
    programs.docker = {
      enable = mkEnableOption "Docker";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];
    home.activation.docker = pkgs.hmpkgs.linkApplication { appName = "Docker.app"; };
  };
}
