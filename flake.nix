{
  description = "spw's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      # Set once here; passed to every module as the `username` argument.
      username = "spw";
      hostname = "Seans-MacBook-Pro";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit username; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "before-home-manager";
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.users.${username} = import ./nix/home.nix;
          }
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };

      # Linux (any distro with Nix installed): home-manager on its own, no
      # system layer. Same home.nix; its macOS-only parts are guarded with
      # pkgs.stdenv.hostPlatform.isDarwin. Apply with:
      #   nix run home-manager -- switch --flake ~/.dotfiles#spw@linux
      # For an ARM machine, change x86_64-linux below to aarch64-linux.
      homeConfigurations."${username}@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # nix-darwin supplies osConfig on macOS; there's no system config here.
        extraSpecialArgs = { inherit username; osConfig = null; };
        modules = [
          ./nix/home.nix
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
            # Standalone home-manager installs its own CLI for later switches.
            programs.home-manager.enable = true;
          }
        ];
      };
    };
}
