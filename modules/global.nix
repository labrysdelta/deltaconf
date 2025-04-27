{ inputs, config, pkgs, ... }:

{

	# bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		trusted-users = [ "delta" ] ;
		};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 14d";
	};

	networking = {
		networkmanager = {
			enable = true; # allow startup on boot
		};
		nameservers = [ "1.1.1.1" ];
		enableIPv6 = false;
		nat = {
			enable = true;
			internalInterfaces = [ "ve-+" ];
			externalInterfaces = "wlan0";
		};
	};

	# timezone
	time.timeZone = "Canada/Pacific";

	# sel internationalization/locale stuff
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extrai18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

	# conf keymap in x11
	services.xserver = {
		xkb.layout = "us";
		xkb.variant = "";
	};

	# cachix
	# nix.settings = {
	#	substituters = [ "https://hyprland.cachix.org" ];
	#	trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
	# };

	# users.users.root.openssh.authorizedKeys.keys = [
	# 	
	# ];

	# define user acct, dont forget to set password with passwd
	users.users.delta = {
		isNormalUser = true;
		description = "Delta";
		extraGroups = [ "networkmanager" "wheel" "wireshark" ];
		shell = pkgs.bash;
	};

	environment.sessionVariables = rec {
		NIXOS_OZONE_WL = "1";

	};

	# allow unfree packages
	nixpkgs.config.allowUnfree = true;
	home-manager.backupFileExtension = "backup";
	home-manager.useGlobalPkgs = false;
	# list installed pkgs, search via
	# $ nix search wget

	qt = {
		enable = true;
		style = "gtk2";
		platformTheme = "gtk2";
	};

	# some programs need SUID wrappers, can config further or start in user sessions
	programs.nix-ld.enable = true;
	programs.nix-ld.libraries = with pkgs; [
		glib
		nss
		nspr
		atkmm
		# add missing dynlibs for unpkgd programs HERE NOT IN environment.systemPackages
	];
	programs.fuse.userAllowOther = true;
	programs.xfconf.enable = true;
	programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};
	programs.mosh.enable = true;
	programs.bash.enable = true;

	# list services to enable
	services.tumbler.enable = true;
	services.envfs.enable = true;
	services.thermald.enable = true;
	services.printing = {
		enable = true;
		drivers = [ pkgs.gutenprint pkgs.hplip];
	};
	services.atd.enable = true;
	services.cron.enable = true;
	services.blueman.enable = true;
	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};

	services.logind.extraConfig = ''
		HandleLidSwitch=suspend-then-hibernate
		HandlePowerKey=poweroff
		'';

	security.rtkit.enable = true;
	security.soteria.enable = true;
	services.pipewire = {
		enable = true;
		audio.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
		wireplumber.enable = true;
	};

	services.flatpak.enable = true;

	# enable openssh daemon
	services.openssh.enable = true;

	services.gvfs.enable = true;

	# mount on /media
	services.udisks2.enable = true;
	services.udisks2.mountOnMedia = true;

	services.locate = {
		enable = true;
		package = pkgs.plocate;
	};

	# if you ever need appimages this is magic code that does magic
	boot.binfmt.registrations.appimage = {
		wrapInterpreterInShell = false;
		interpreter = "${pkgs.appimage-run}/bin/appimage-run";
		recognitionType = "magic";
		offset = 0;
		mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
		magicOrExtension = ''\x7fELF....AI\x02'';
	};

	# open ports in firewall below
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# or disable altogether
	# networking.firewall.enable = false

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It is perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	# system.stateVersion = "23.11"; # Did you read the comment?

	security.polkit.enable = true;
	security.sudo.extraConfig = "Defaults insults";

	hardware.bluetooth.enable = false; # change to true if needed
	hardware.bluetooth.powerOnBoot = false; # bluetooth on boot

	hardware.graphics.enable = true;

}
