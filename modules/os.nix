{ inputs, config, pkgs, ... }:

# these are pkgs and conf specifically required for slimmest base state
{
	environment.systemPackages = with pkgs;
		[
		brightnessctl
		nano
		neofetch
		networkmanagerapplet
		openvpn
		home-manager
		konsole
		libcamera
		libGL
		trashy
		udiskie
		wl-clipboard
		wtype
		kdePackages.xwaylandvideobridge
		zoxide
		];

	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
	};

	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		nerd-fonts.fira-code
		mplus-outline-fonts.githubRelease
		dina-font
		proggyfonts
		garamond-libre
	];

	services.displayManager = {
		sddm.enable = true;
		sddm.theme = "Elegant/";
		sddm.wayland.enable = true;
	};

	services.desktopManager.plasma6.enable = true;

}
