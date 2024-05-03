{ pkgs, inputs, mwpkgs, ... }: let 
  starship = "${mwpkgs.starship}/bin/starship";
  direnv = "${pkgs.direnv}/bin/direnv";
in ''
  if status is-interactive
    abbr --add osswitch sudo nixos-rebuild switch
    abbr --add ostest sudo nixos-rebuild test

    ${starship} init fish | source
    ${direnv} hook fish | source
  end
''
