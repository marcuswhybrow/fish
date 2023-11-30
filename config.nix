{ pkgs, ... }: let 
  hyprland = "${pkgs.hyprland}/bin/Hyprland";
  tmux = "${pkgs.tmux}/bin/tmux";
  vim = "${pkgs.neovim}/bin/neovim";
  git = "${pkgs.git}/bin/git";
  starship = "${pkgs.starship}/bin/starship";
  direnv = "${pkgs.direnv}/bin/direnv";
in ''
  if status is-login
    if [ (hostname) = "marcus-laptop" ]
      ${hyprland}
    end
  end

  if status is-interactive
    abbr --add n "${tmux} new -A -s nixos -c ~/.nixos"
    abbr --add c "${tmux} new -A -s config -c ~/.config"
    abbr --add r work_on_repository

    abbr --add t ${vim} ~/obsidian/Timeline/$(date +%Y-%m-%d).md
    abbr --add y ${vim} ~/obsidian/Timeline/$(date +%Y-%m-%d --date yesterday).md

    abbr --add osswitch sudo nixos-rebuild switch
    abbr --add ostest sudo nixos-rebuild test

    abbr --add gs ${git} status
    abbr --add ga ${git} add .
    abbr --add gc ${git} commit
    abbr --add gp ${git} push
    abbr --add gd ${git} diff

    ${starship} init fish | source
    ${direnv} hook fish | source
  end
''