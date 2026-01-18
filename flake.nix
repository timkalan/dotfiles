{
  description = "One Flake to rule them all";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      username = "timkalan";
    in
    {
      darwinConfigurations."diego" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self username inputs; };
        modules = [
          ./hosts/diego
        ];
      };

      nixosConfigurations."davor" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self username inputs; };
        modules = [
          ./hosts/davor

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit username inputs; };
              users.${username} = import ./hosts/davor/home.nix;
            };
          }
        ];
      };
    };
}
