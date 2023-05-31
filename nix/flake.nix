{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, darwin, home-manager, neovim-overlay, rust-overlay, ... }: {
    darwinConfigurations = {
      ikas-Virtual-Machine = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          ({ pkgs, ... } @ args: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ika = import ./users/ika.nix args;
            users.users.ika.home = /Users/ika;
          })
          ({ pkgs, ... }: {
            nix.settings.trusted-users = [ "ika" ];
            services.nix-daemon.enable = true;

            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              # neovim-overlay.overlay
              rust-overlay.overlays.default
            ];
          })
        ];
      };
    };
  };
}

