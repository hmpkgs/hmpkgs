{ config, pkgs, lib, ... }:

let defaultToken = builtins.getEnv "GITHUB_PUBLIC_REPO_TOKEN";

in {
  config.nixpkgs.overlays = [(self: super: {

    org-export = { source, user, repo, token ? defaultToken }: let
      pkgGen = pkgs.emacsPackagesNgGen pkgs.emacs;
      # install htmlize for emacs
      emacs = pkgGen.emacsWithPackages (epkgs: [ epkgs.htmlize ]);
      # calculate the url of the repository
      giturl = "https://${user}:${token}@github.com/${user}/${repo}.git";
      # export Orgmode file to HTML and upload to Github Pages
      env = { buildInputs = [ emacs pkgs.git ]; };
      script = ''
        ln -s "${source}" ./init.org;
        emacs -Q --script ${./org-export.el} -f export-init-to-html;
        mv init.html index.html
        git init;
        git checkout -b gh-pages
        git remote add origin "${giturl}"
        git add index.html;
        git commit -m "autodeploy";
        git push --force origin gh-pages;
        cp ./index.html $out;
      '';
    in pkgs.runCommand "org-export" env script;

  })];
}

