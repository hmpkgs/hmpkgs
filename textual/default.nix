{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.textual;

  package = pkgs.hmpkgs.installApplication rec {
    name = "Textual";
    version = "unknown";
    src = pkgs.fetchurl {
      url = "https://www.codeux.com/textual/downloads/Textual7.dmg";
      sha256 = "06cdiwrr1ihrgjhpcfwsvlyyypmcprl8dgf7h95d2ln6pwrkgr8z";
    };
    sourceRoot = "Textual.app";
    description = "Textual IRC for OSX";
    homepage = https://www.textual.com/;
  };

in {
  options = {
    programs.textual = {
      enable = mkEnableOption "Textual";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];
    home.activation.textual = pkgs.hmpkgs.linkApplication { appName = "Textual.app"; };
  };
}
