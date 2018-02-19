{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.licecap;
  appVersion = "128";

  package = pkgs.hmpkgs.installApplication rec {
    name = "Licecap";
    version = appVersion;
    src = pkgs.fetchurl {
      url = "https://www.cockos.com/licecap/licecap${appVersion}.dmg";
      sha256 = "1inv78zpfs5yqp5w566pngjy0lhvpifwx6yz6ds2jj009g9qq30k";
    };
    sourceRoot = "Licecap.app";
    description = "GIF recorder for OSX";
    homepage = https://www.cockos.com/licecap/;
  };

in {
  options = {
    programs.licecap = {
      enable = mkEnableOption "Licecap";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];
    home.activation.licecap = pkgs.hmpkgs.linkApplication { appName = "Licecap.app"; };
  };
}
