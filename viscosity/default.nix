{ config, pkgs, lib, ... }:

with import <home-manager/modules/lib/dag.nix> { inherit lib; };
with lib;
with builtins;

let
  appName = "Viscosity.app";
  cfg = config.programs.viscosity;

  package = pkgs.stdenv.mkDerivation rec {
    name = appName;
    src = pkgs.fetchurl {
      url = "https://www.sparklabs.com/downloads/Viscosity.dmg";
      sha256 = "116zqkxjka99z9rk7bmabwbv0aghprxs2y76n8yy6mwfrwmksjzk";
    };

    buildInputs = [ pkgs.undmg ];
    installPhase = ''
      source $stdenv/setup
      mkdir -pv $out/Applications/${appName}
      cp -r ./* $out/Applications/${appName}
    '';

    meta = {
      description = "VPN client for macOS";
      homepage = https://www.sparklabs.com/viscosity/;
      platforms = pkgs.stdenv.lib.platforms.darwin;
    };
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
    home.activation.viscosity = dagEntryAfter["installPackages"] (let
      home = config.home.homeDirectory;
      applications = "${home}/.nix-profile/Applications";
      source = "${applications}/${appName}";
      target = "${home}/Applications/";
    in ''
      if [ -e ${target}/${appName} ]; then
        rm -r ${target}/${appName}
      fi
      osascript << EOF
        tell application "Finder"
        set mySource to POSIX file "${source}" as alias
        make new alias to mySource at POSIX file "${target}"
        set name of result to "${appName}"
      end tell
      EOF
    '');
  };
}
