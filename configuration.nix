{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
	
    programs.hyprland = {
	enable = true;
	xwayland.enable = true;
    };

    environment.sessionVariables = {
	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";
	XCURSOR_THEME = "Adwaita";
	XCURSOR_SIZE = "24";
    };

    # Agregando PostgreSQL
    services.postgresql = {
	enable = true;
	ensureDatabases = [ "MyDataBase" ];
	authentication = pkgs.lib.mkOverride 10 ''
	#type Database DBuser auth-method
	local all      all    trust
	'';
    };

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.devices = [ "nodev" ];

  # Use kernel 6.5 para compatibilidad Nvidia.
  boot.kernelPackages = pkgs.linuxPackages_6_16;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Esto lo que hace es habilitar los flakes y sus comandos
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
   networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Managua";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_NI.UTF-8";

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Nvidia propietary drivers
  hardware.graphics.enable = true;
  hardware.nvidia.open = false;
  # Para configurar PRIME y poder usar ambas GPU's y poder usar offload
  services.xserver.videoDrivers = [
  	"modesetting" # Intel
	"nvidia" # Nvidia

  ];  

  hardware.nvidia.prime = {
  	offload.enable = true; # Para activar offload mode
	offload.enableOffloadCmd = true; # Para generar Nvidia-offload
  	intelBusId = "PCI:0:2:0"; # Grafica Intel
	nvidiaBusId = "PCI:1:0:0"; # Grafica Nvidia
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.silviom = {
    isNormalUser = true;
    description = "Silvio Mejia";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.neovim.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  lf
  obsidian  
  spotify
  ghostty
  pciutils # Importante para definir y configurar PRIME
  jetbrains.pycharm-professional
  jetbrains.idea-ultimate
  jdk17
  jdk21
  python312Full
  git
  wget
  discord
  pgadmin4-desktopmode
  hyprland
  waybar
  wofi
  nwg-look
  hyprpicker
  swww
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  brightnessctl
  vscode
  adwaita-icon-theme
  jetbrains-toolbox
  ];

  xdg.portal = {
  	enable = true;
	extraPortals = with pkgs; [
		xdg-desktop-portal-gtk
		xdg-desktop-portal-hyprland
	];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

