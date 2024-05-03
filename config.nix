{ pkgs, inputs, mwpkgs, ... }: let 
  neovim = "${mwpkgs.neovim}/bin/vim";
  starship = "${mwpkgs.starship}/bin/starship";
  direnv = "${pkgs.direnv}/bin/direnv";
in ''
  if status is-interactive
    abbr --add n "tmux new -A -s nixos -c ~/.nixos"
    abbr --add c "tmux new -A -s config -c ~/.config"
    abbr --add r work_on_repository

    abbr --add t ${neovim} ~/obsidian/Timeline/$(date +%Y-%m-%d).md
    abbr --add y ${neovim} ~/obsidian/Timeline/$(date +%Y-%m-%d --date yesterday).md

    abbr --add osswitch sudo nixos-rebuild switch
    abbr --add ostest sudo nixos-rebuild test

    ${starship} init fish | source
    ${direnv} hook fish | source
  end
''
