{ pkgs, inputs, ... }: let 
  direnv = "${pkgs.direnv}/bin/direnv";
in ''
  if status is-interactive
    abbr --add osswitch sudo nixos-rebuild switch
    abbr --add ostest sudo nixos-rebuild test
    ${direnv} hook fish | source
  end
''
