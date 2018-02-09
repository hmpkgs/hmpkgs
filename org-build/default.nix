{ config, pkgs, lib, ... }:

{
  config.nixpkgs.overlays = [(self: super: {

    org-build = { source }: let
      # the build uses emacs to perform the conversion
      env = { buildInputs = [ pkgs.emacs ]; };
      # call make-init-el to convert the file
      script = { source }: ''
        ln -s "${source}" ./init.org;
        emacs -Q --script "${./org-build.el}" -f make-init-el;
        cp ./init.el $out;
      '';
    in pkgs.runCommand "org-build" env (script { inherit source; });

  })];
}

