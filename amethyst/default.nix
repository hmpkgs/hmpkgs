{ config, pkgs, lib, ... }:

with import <home-manager/modules/lib/dag.nix> { inherit lib; };
with lib;

let
  cfg = config.programs.amethyst;

  package = pkgs.hmpkgs.installApplication rec {
    name = "Amethyst";
    version = "0.11.0";
    src = pkgs.fetchurl {
      url = "https://github.com/ianyh/Amethyst/releases/download/v${version}/Amethyst-${version}.zip";
      sha256 = "0k1jnkdppxv7ya5fnxxj8nw4a2z2k9nn20i0nm2ifqzzhzklvhyh";
    };
    sourceRoot = "Amethyst.app";
    description = "Tiling window manager for OSX";
    homepage = https://github.com/ianyh/Amethyst;
  };

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

    home.activation.amethyst = pkgs.hmpkgs.linkApplication { appName = "Amethyst.app"; };

    home.file.".amethyst".source = cfg.initFile;
  };
}
