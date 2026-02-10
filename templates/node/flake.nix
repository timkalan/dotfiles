{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_24
            pnpm
            typescript

            # LSPs and language servers
            tailwindcss-language-server
            vscode-langservers-extracted
            vtsls

            # Formatters
            biome
            # prettierd

            # Tailwind class sorter
            rustywind

            infisical
          ];

          shellHook = ''
            echo "Node $(node --version) ready"
          '';
        };
      });
    };
}
