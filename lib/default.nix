{ nixpkgs, ... }:

with nixpkgs.lib;

let

  # Searches Nix path by prefix
  # Example: findNixPath "nixos-config"
  findNixPath = prefix:
    pipe builtins.nixPath [
      (findFirst (p: p.prefix == prefix) null)
      (mapNullable (p: p.path))
    ];

  # Type: importDirToAttrs :: Path -> AttrSet
  importDirToAttrs = root:
    pipe root [
      filesystem.listFilesRecursive
      (filter (hasSuffix ".nix"))
      (map (path: {
        name = pipe path [
          toString
          (removePrefix "${toString root}/")
          (removeSuffix "/default.nix")
          (removeSuffix ".nix")
          kebabCaseToCamelCase
          (replaceStrings [ "/" ] [ "-" ])
        ];
        value = import path;
      }))
      listToAttrs
    ];

  # Type: kebabCaseToCamelCase :: String -> String
  kebabCaseToCamelCase = replaceStrings (map (s: "-${s}") lowerChars) upperChars;

in
{
  inherit findNixPath importDirToAttrs kebabCaseToCamelCase;

  nerdfonts = importDirToAttrs ./nerdfonts;

  font-awesome = import ./font-awesome.nix;

  importNixosConfig = mapNullable import (findNixPath "nixos-config");

  /* Replace strings by attrset
    Type: substitueStrings :: AttrSet -> String -> String
  */
  substitueStrings = m: replaceStrings (attrNames m) (map toString (attrValues m));

  unionOfDisjoint = x: y:
    let
      intersection = builtins.intersectAttrs x y;
      collisions = lib.concatStringsSep " " (builtins.attrNames intersection);
      mask = builtins.mapAttrs
        (name: value: builtins.throw
          "unionOfDisjoint: collision on ${name}; complete list: ${collisions}")
        intersection;
    in
    (x // y) // mask;
}
