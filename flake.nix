{
  description = "One Flake to rule them all";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    herdr.url = "github:herdrdev/herdr";
    herdr.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";

    elephant.url = "github:abenz1267/elephant";
    walker.url = "github:abenz1267/walker";
    walker.inputs.elephant.follows = "elephant";
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
      # placeholder — set the real work email locally on the work host
      workEmail = "you@company.example";
      keys = {
        identity = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgcuYjqqJvCVfJgxCWvjRluyx6OoqdNVXUJdz2n3y5Z";
      };
    in
    {
      darwinConfigurations."diego" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit
            self
            username
            keys
            inputs
            ;
        };
        modules = [
          ./hosts/diego

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit
                  username
                  fullName
                  email
                  workEmail
                  inputs
                  keys
                  ;
              };
              users.${username} = {
                imports = [
                  ./hosts/diego/home.nix
                ];
              };
            };
          }
        ];
      };

      darwinConfigurations."dagda" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit
            self
            username
            keys
            inputs
            ;
        };
        modules = [
          ./hosts/dagda

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit
                  username
                  fullName
                  email
                  workEmail
                  inputs
                  keys
                  ;
                isWork = true;
              };
              users.${username} = {
                imports = [
                  ./hosts/dagda/home.nix
                ];
              };
            };
          }
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
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit
                  username
                  fullName
                  email
                  workEmail
                  inputs
                  keys
                  ;
              };
              users.${username} = {
                imports = [
                  ./hosts/davor/home.nix
                  inputs.walker.homeManagerModules.default
                ];
              };
            };
          }
        ];
      };

      nixosConfigurations."devon" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
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
          ./hosts/devon

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit
                  username
                  fullName
                  email
                  workEmail
                  inputs
                  keys
                  ;
              };
              users.${username} = {
                imports = [
                  ./hosts/devon/home.nix
                ];
              };
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
