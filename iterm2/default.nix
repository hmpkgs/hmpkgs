{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.iterm2;

  package = pkgs.hmpkgs.installApplication rec {
    name = "iTerm2";
    version = "3.1.6beta1";
    src = pkgs.fetchzip {
      name = name;
      url = "https://iterm2.com/downloads/beta/iTerm2-3_1_6beta1.zip";
      sha256 = "1qxfnp1yaw476nnbj1r920klpf890pz11vi9dkkg6y0h27b80zli";
    };
    sourceRoot = name;
    description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com;
  };

in {
  options = {
    programs.iterm2 = {
      enable = mkEnableOption "iTerm2";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];
    home.activation.iterm2 = pkgs.hmpkgs.linkApplication { appName = "iTerm2.app"; };
  };
}
