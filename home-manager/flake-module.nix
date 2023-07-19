toplevel@{ self, inputs, ... }:

let
  mkHmLib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix";
  mkMyLib = import ../lib/extended.nix;
in
{
  # flake = rec {
  #   homeManagerModules.default = import ./module.nix;
  #   homeManagerModule = homeManagerModules.default;
  # };

  perSystem = ctx@{ options, config, self', inputs', pkgs, lib, system, ... }:
    let
      inherit (pkgs.stdenv) isLinux isDarwin;

      extraSpecialArgs = {
        inherit inputs;
        # inherit (inputs) home-manager; # TODO find what's referencing this
        lib = mkHmLib (mkMyLib lib); # extend lib with .my and .hm
        inherit (config) flake-root;
        flake = self; # remove usage
        nerdfonts = import ../lib/nerdfonts; # TODO can get rid of this now with lib.my.nerdfonts
        nix-colors = import ../nix-colors/extended.nix inputs;
      };

      commonModules = [
        inputs.sops-nix.homeManagerModule
        # inputs.emanote.homeManagerModule
        {
          nixpkgs.overlays = [
            inputs.rust-overlay.overlays.default
            inputs.emacs.overlays.default
          ];
        }
        {
          # TODO make into homeManagerModules.my?
          options.my = ctx.options.my;
          config.my = ctx.config.my;
        }
      ];
    in
    {
      legacyPackages =
        (lib.optionalAttrs (system == "x86_64-linux") {
          homeConfigurations."logan@nijusan" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs extraSpecialArgs;
            modules = commonModules ++ [ ./nijusan.nix ];
          };
        })
        // (lib.optionalAttrs (system == "aarch64-darwin") {
          # TODO move to nix-darwin
          darwinConfigurations.patchbook = inputs.darwin.lib.darwinSystem {
            inherit system;
            # FIXME: commonModules should be used in both...
            modules = commonModules ++ [
              ../nix-darwin/patchbook.nix
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = extraSpecialArgs;
                home-manager.users.logan = { options, config, ... }: {
                  imports = commonModules ++ [ ./patchbook.nix ];
                };
              }
            ];
          };
        });
    };
}
