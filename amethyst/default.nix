{ config, pkgs, lib, ... }:

with import <home-manager/modules/lib/dag.nix> { inherit lib; };
with lib;

let
  cfg = config.programs.amethyst;

  version = "0.11.0";

  release = pkgs.fetchzip {
    name = "Amethyst.app";
    url = "https://github.com/ianyh/Amethyst/releases/download/v${version}/Amethyst-${version}.zip";
    sha256 = "1q4w6288lih6wsrp10ig4nryzbahkrrvdwhrka4d6nmr2h64s6b5";
  };

  package = pkgs.runCommandCC "Amethyst-${version}" {} ''
    source $stdenv/setup
    mkdir -pv $out/Applications/Amethyst.app
    cp -r ${release}/* $out/Applications/Amethyst.app
  '';

in {
  options = {
    programs.amethyst = {
      enable = mkEnableOption "Amethyst";
      initFile  = mkOption {
        type = types.path;
        description = "The .amethyst file to use";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];

    home.activation.amethyst = dagEntryAfter["installPackages"] (let
      linkName = "Amethyst.app";
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

    home.file.".amethyst".source = cfg.initFile;
  };
}
