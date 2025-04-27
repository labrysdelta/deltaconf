{
	description = "Delta Labrysmoder's config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		lix-module = {
			url = "git+https://git.lix.systems/lix-project/nixos-module";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = { self, nixpkgs, lix-module, home-manager, nixos-hardware, ... }@inputs:
		let
			commonModules = [
				lix-module.nixosModules.default
				home-managers.nixosModules.home-manager
				{
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = {inherit inputs;};
					home-manager.users.delta = {
						imports = [
							./home/default.nix
						];
					};
				}
			];
		in
		{
			nixosConfigurations = {
				medea = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					specialArgs = { inherit inputs; };
					modules = [
						./hosts/medea/local.nix
						nixos-hardware.nixosModules.hp-laptop-14s-dq2024nf
					]
					++ commonModules;
				};

			};
		}
}
