{
  description = "Fish shell configured by Marcus";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-updates.url = "github:marcuswhybrow/flake-updates";
  };

  outputs = inputs: let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    flakeUpdates = inputs.flake-updates.packages.x86_64-linux.flake-updates;
    direnv = "${pkgs.direnv}/bin/direnv";

    config = pkgs.writeTextDir "share/fish/vendor_conf.d/config.fish" /* fish */ ''
      if status is-interactive
        abbr --add osswitch sudo nixos-rebuild switch
        abbr --add ostest sudo nixos-rebuild test
        ${direnv} hook fish | source
      end
    '';

    fish_greeting = pkgs.writeTextDir "share/fish/vendor_functions.d/fish_greeting.fish" /* fish */ ''
      function fish_greeting
        echo (whoami) @ (hostname)
        set updates (${flakeUpdates}/bin/flake-updates --flake ~/Repos/nixos --output '%s' --defer)
        if test -n "$updates"
          echo "$updates updates available (2)"
        end
      end
    '';
  in {
    packages.x86_64-linux.fish = pkgs.symlinkJoin {
      name = "fish";
      paths = [ 
        pkgs.fish 
        config 
        fish_greeting 
      ];
    };
    packages.x86_64-linux.default = inputs.self.packages.x86_64-linux.fish;
  };
}
