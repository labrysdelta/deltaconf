{ config, pkgs, hp-laptop-14s-dq2024nf, ... }:

{
	system.nixos.label = "medea";

	imports =
		[
			# Include the results of the hardware scan
			./hardware-configuration.nix
		];

		networking.hostName = "medea";
		powerManagement.enable = true;

		services.tlp = {
			enable = true;
			settings = {
				CPU_SCALING_GOVERNOR_ON_AC = "performance";
				CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

				CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
				CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

				CPU_MIN_PERF_ON_AC = 0;
				CPU_MAX_PERF_ON_AC = 100;
				CPU_MIN_PERF_ON_BAT = 0;
				CPU_MAX_PERF_ON_BAT = 20;

				# Save longterm battery health
				START_CHARGE_THRESH_BAT0 = 40; # 40 and below starts charging
				STOP_CHARGE_THRES_BAT0 = 80; # 80 and above stops charging

		};
	};
}
