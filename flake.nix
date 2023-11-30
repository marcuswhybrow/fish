{
  description = "Fish shell configured by Marcus";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs: let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    configText = import ./config.nix { inherit pkgs inputs; };
    config = pkgs.writeTextDir "share/fish/vendor_conf.d/config.fish" configText;
    functions = {
      fish_greeting = ''echo (whoami) @ (hostname)'';
      code = ''
        set name (ls $HOME/Repositories | fzf --bind tab:up,btab:down)
        tmux new \
          -A \
          -s $name \
          -c $HOME/Repositories/$name

      '';
    };
    mkFunctionPkg = name: def: (pkgs.writeTextDir "share/fish/vendor_functions.d/${name}.fish" ''
      function ${name}
        ${def}
      end
    '');
    functionPkgs = pkgs.lib.mapAttrsToList mkFunctionPkg functions;
  in {
    packages.x86_64-linux.fish = pkgs.symlinkJoin {
      name = "fish";
      paths = [ pkgs.fish config ] ++ functionPkgs;
    };
    packages.x86_64-linux.default = inputs.self.packages.x86_64-linux.fish;
  };
}
