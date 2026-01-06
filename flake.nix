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
    inputs@{ self, nix-darwin, ... }:
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
    };
}
