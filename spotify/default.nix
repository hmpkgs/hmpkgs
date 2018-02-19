{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.spotify;

  package = pkgs.hmpkgs.installApplication rec {
    name = "Spotify";
    version = "unknown";
    src = pkgs.fetchurl {
      url = "http://download.spotify.com/Spotify.dmg";
      sha256 = "1sszll6950s4v638dlk6h58xli6baswidlnm2xw41fdzw7v2ms9p";
    };
    sourceRoot = "Spotify.app";
    description = "Spotify music for OSX";
    homepage = https://www.spotify.com/;
  };

in {
  options = {
    programs.spotify = {
      enable = mkEnableOption "Spotify";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];
    home.activation.spotify = pkgs.hmpkgs.linkApplication { appName = "Spotify.app"; };
  };
}
