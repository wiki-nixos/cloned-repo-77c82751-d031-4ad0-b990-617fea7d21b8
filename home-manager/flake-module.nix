{ self, inputs, ... }:

{
  # flake = rec {
  #   homeManagerModules.default = import ./module.nix;
  #   homeManagerModule = homeManagerModules.default;
  # };

  perSystem = ctx@{ options, config, self', inputs', pkgs, system, ... }:
    let
      lib = self.lib.mkHmLib ctx.lib;

      nix-colors = import ../nix-colors/extended.nix inputs;

      extraSpecialArgs = {
        inherit inputs lib self' inputs' nix-colors;
        flake = { inherit self inputs; };
      };

      commonModules = [
        (import ../nix/nixpkgs.nix self)
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
            modules = commonModules ++ [
              ./nijusan.nix
            ];
          };
        })
        # // (lib.optionalAttrs (system == "aarch64-darwin") {
        #   # TODO move to nix-darwin
        #   darwinConfigurations.patchbook = inputs.nix-darwin.lib.darwinSystem {
        #     inherit system;
        #     # FIXME: commonModules should be used in both...
        #     modules = [
        #       # ../nix-darwin/patchbook.nix
        #       inputs.home-manager.darwinModules.home-manager
        #       {
        #         home-manager.useGlobalPkgs = true;
        #         home-manager.useUserPackages = true;
        #         home-manager.extraSpecialArgs = extraSpecialArgs;
        #         home-manager.users.logan = { options, config, ... }: {
        #           imports = commonModules;
        #           home.stateVersion = "22.11";
        #         };
        #       }
        #       {
        #         system.stateVersion = 4;
        #       }
        #     ]
        #     ++ commonModules
        #     ;
        #   };
        # });
        ;
    };
}
