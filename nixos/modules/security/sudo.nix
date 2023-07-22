{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.sudo;

in

{
  options.my.sudo = {
    commands = mkOption {
      type = with types; listOf (either str (submodule {
        options = {
          command = mkOption {
            type = with types; str;
          };
          options = mkOption {
            type = with types; listOf (enum [ "NOPASSWD" "PASSWD" "NOEXEC" "EXEC" "SETENV" "NOSETENV" "LOG_INPUT" "NOLOG_INPUT" "LOG_OUTPUT" "NOLOG_OUTPUT" ]);
            default = [ ];
          };
        };
      }));
      default = { };
    };
  };
  config = {
    security.sudo = {
      package = pkgs.sudo.override { withInsults = true; }; # do your worst.
      extraRules = [{
        inherit (cfg) commands;
        groups = [ "wheel" ];
      }];
    };
  };
}
