{ config, pkgs, lib, ... }:

with lib;
with builtins;

let
  appName = "Viscosity.app";
  cfg = config.programs.viscosity;

  package = pkgs.hmpkgs.installApplication rec {
    name = "Viscosity";
    version = "1.7.6";
    src = pkgs.fetchurl {
      url = "https://www.sparklabs.com/downloads/Viscosity.dmg";
      sha256 = "116zqkxjka99z9rk7bmabwbv0aghprxs2y76n8yy6mwfrwmksjzk";
    };
    sourceRoot = "${name}.app";
    description = "Viscosity is a VPN client for OSX";
    homepage = https://www.sparklabs.com/viscosity/;
  };


  remoteOption = types.submodule {
    options = {
      host = mkOption { type = types.str; };
      port = mkOption { type = types.int; };
      type = mkOption { type = types.enum [ "udp" "tcp-client" ]; };
    };
  };

  mkConfig = i: name: let
    connection = getAttr name cfg.connections;
    remotes = map (r: "remote ${r.host} ${toString r.port} ${r.type}") connection;
    remoteSection = concatStringsSep "\n" remotes;
    substitutes = [name remoteSection];
    template = readFile ./template.conf;
    text = replaceStrings [ "@name@" "@remotes@" ] substitutes template;
  in {
    name = "Library/Application Support/Viscosity/OpenVPN/${toString i}/config.conf";
    value.text = text;
  };

  connectionNames = attrNames cfg.connections;
configFiles = imap1 mkConfig connectionNames;



in {
  options = {
    programs.viscosity = {
      enable = mkEnableOption "Viscosity";
      connections = mkOption { type = types.attrsOf (types.listOf remoteOption); };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];
    home.file = listToAttrs configFiles;
    home.activation.viscosity = pkgs.hmpkgs.linkApplication { appName = "Viscosity.app"; };
  };
}
