# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "lucy-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.udev.extraRules = ''
	SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
    # Gamepad emulation
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    # Sony DualShock 4
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
  '';

  # Enable proprietary NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Enable flatpaks
  services.flatpak.enable = true;

  # Desktop integration portal
  xdg.portal.extraPortals = [ pkgs.plasma5.xdg-desktop-portal-kde  ];

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lucy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    vim
    nano
    micro
    lmms
    carla
    (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ]; nativeOnly = false; })
	steam-run
    aseprite
    vscodium
    godot
    keepassxc
    zsh
    fish 
    firefox
    ark
    git
    discord
    glxinfo
    arc-theme
    arc-kde-theme
    papirus-icon-theme
    wineWowPackages.stable
	usbutils
    htop
	kate
	etcher
	grub2
	parted
	gparted	
	testdisk
	appimage-run
	linuxPackages.virtualbox
	plasma5.sddm-kcm
	kde-gtk-config
	patchelf
	gcc
	hivex
    libsForQt512.qtstyleplugin-kvantum
    qtstyleplugin-kvantum-qt4
    nur.repos.zeratax.mangohud
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  nixpkgs.config.allowBroken = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "lucy" ];


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
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
  system.stateVersion = "20.09"; # Did you read the comment?

}

