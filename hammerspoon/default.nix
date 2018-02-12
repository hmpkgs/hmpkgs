{ config, pkgs, lib, ... }:

with import <home-manager/modules/lib/dag.nix> { inherit lib; };
with lib;

let
  cfg = config.programs.hammerspoon;

  package = pkgs.hmpkgs.installApplication rec {
    name = "Hammerspoon";
    version = "0.9.57";
    src = pkgs.fetchzip {
      name = name;
      url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
      sha256 = "12j9vylcxb7i3bn0v5x6zbxmnyyp7gh4am4vg48yv3hb54i73klx";
    };
    sourceRoot = name;
    description = "Like Applescript, but Lua!";
    homepage = "";
  };

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
    home.activation.hammerspoon = pkgs.hmpkgs.linkApplication { appName = "Hammerspoon.app"; };
    home.file.".hammerspoon/init.lua".source = cfg.initFile;
  };
}
