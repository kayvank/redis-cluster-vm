# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use a pinned version of nixpkgs
    # Optionally add other inputs like home-manager
  };

  outputs = inputs@{ self, nixpkgs, ... }: let
    system = "x86_64-linux"; # Define the target system architecture
    redis-vm = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        vm-configs = import ./hosts/redis-vm.nix ;
        inherit inputs;
      };

      modules = [
        ./modules/system/configuration.nix
        # Add any other modules here
      ];
    };
  in {
    # Expose the configuration as a NixOS configuration
    nixosConfigurations.test = redis-vm;

    # Expose the VM build attribute directly for convenience
    vms.box = redis-vm.config.system.build.vm;

    # Optional: Expose a runnable app for convenience
    apps.test = {
      type = "app";
      program = "${redis-vm.config.system.build.vm}/bin/run-nixos-vm";
    };
    defaultApp = self.apps.test;



    devShells.${system} = {
  default = nixpkgs.legacyPackages.${system}.mkShell {
        # Add packages to be available in the shell (e.g., git, curl, cowsay)
    packages = with nixpkgs.legacyPackages.${system}; [
          git
          curl
          cowsay
          redis
        ];

        # Set environment variables or run commands when entering the shell
        shellHook = ''
          echo "Welcome to the Nix devshell!"
          export MY_VAR="some value"
        '';
      };
      };





  };

}
