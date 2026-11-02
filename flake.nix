{
  description = "spw's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, ... }: {
    darwinConfigurations."Seans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./nix/darwin.nix
        { system.configurationRevision = self.rev or self.dirtyRev or null; }
      ];
    };
  };
}
