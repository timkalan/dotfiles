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
      fullName = "Tim Kalan";
      email = "timkalan99@gmail.com";
      workEmail = "tim.kalan@zerodays.dev";
      keys = {
        diego = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgcuYjqqJvCVfJgxCWvjRluyx6OoqdNVXUJdz2n3y5Z";
        davor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc1JHW7HfZxlNrIxHEnsfy3kqG1mhMSwupx9z4zLJrn";
      };
    in
    {
      darwinConfigurations."diego" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit
            self
            username
            fullName
            email
            workEmail
            keys
            inputs
            ;
        };
        modules = [
          ./hosts/diego
        ];
      };

      nixosConfigurations."davor" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            self
            username
            fullName
            email
            workEmail
            keys
            inputs
            ;
        };
        modules = [
          ./hosts/davor

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit
                  username
                  fullName
                  email
                  workEmail
                  inputs
                  ;
              };
              users.${username} = import ./hosts/davor/home.nix;
            };
          }
        ];
      };

      templates = {
        node = {
          path = ./templates/node;
          description = "Node.js development environment with nodejs_24, corepack, and infisical";
        };
        go = {
          path = ./templates/go;
          description = "Go development environment with gopls, gofumpt, golangci-lint";
        };
        python = {
          path = ./templates/python;
          description = "Python development environment with uv, pyright, and ruff";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust development environment with cargo, rust-analyzer, and clippy";
        };
        default = self.templates.node;
      };
    };
}
