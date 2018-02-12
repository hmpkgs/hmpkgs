{ config, pkgs, lib, ... }:

{
  config.nixpkgs.overlays = [(self: super: {

    hmpkgs.installApplication =
    { name, version, src, description, homepage,
      postInstall ? "", sourceRoot ? ".", ... }:
    with super; stdenv.mkDerivation (let
      appName = "${name}.app";
    in {
      name = "${name}-${version}";
      version = "${version}";
      src = src;
      buildInputs = [ undmg unzip ];
      sourceRoot = sourceRoot;
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        echo "BUILDING ${appName}"
        ls -la 

        mkdir -p "$out/Applications/${appName}"
        cp -pR * "$out/Applications/${appName}"
      '' + postInstall;
      meta = with lib; {
        platforms = platforms.darwin;
      };
    });

    hmpkgs.linkApplication = {appName}: config.lib.dag.entryAfter["installPackages"] (let
      home = config.home.homeDirectory;
      applications = "${home}/.nix-profile/Applications";
      source = "${applications}/${appName}";
      target = "${home}/Applications/";
    in ''
      echo "FOR ${appName}"
      ls -la

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
  })];
}
