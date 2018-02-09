{ config, pkgs, lib, ... }:

with import <home-manager/modules/lib/dag.nix> { inherit lib; };
with lib;

let
  cfg = config.programs.hammerspoon;

  version = "0.9.57";

  release = pkgs.fetchzip {
    name = "Hammerspoon.app";
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    sha256 = "12j9vylcxb7i3bn0v5x6zbxmnyyp7gh4am4vg48yv3hb54i73klx";
  };

  package = pkgs.runCommandCC "Hammerspoon-${version}" {} ''
    source $stdenv/setup
    mkdir -pv $out/Applications/Hammerspoon.app
    cp -r ${release}/* $out/Applications/Hammerspoon.app
  '';

in {
  options = {
    programs.hammerspoon = {
      enable = mkEnableOption "Hammerspoon";
      initFile  = mkOption {
        type = types.path;
        description = "The init.lua file to use";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];

    home.activation.hammerspoon = dagEntryAfter["installPackages"] (let
      linkName = "Hammerspoon.app";
      home = config.home.homeDirectory;
      applications = "${home}/.nix-profile/Applications";
      source = "${applications}/${linkName}";
      target = "${home}/Applications/";
    in ''
      if [ -e ${target}/${linkName} ]; then
        rm -r ${target}/${linkName}
      fi
      osascript << EOF
        tell application "Finder"
        set mySource to POSIX file "${source}" as alias
        make new alias to mySource at POSIX file "${target}"
        set name of result to "${linkName}"
      end tell
      EOF
    '');

    home.file.".hammerspoon/init.lua".source = cfg.initFile;
  };
}
