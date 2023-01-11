 let
   nix-pre-commit-hooks = import (builtins.fetchTarball {
     url = "https://github.com/cachix/pre-commit-hooks.nix/tarball/master";
     sha256 = "v6U0G3pJe0YaIuD1Ijhz86EhTgbXZ4f/2By8sLqFk4c=";
   });
 in {
   pre-commit-check = nix-pre-commit-hooks.run {
     src = ./.;
     hooks = {
      shellcheck.enable = true;
      alejandra.enable = true;
     };
   };
 }
