{ config, lib, pkgs, nixpkgs, lanzaboote, ... }:

{
  imports = [
      ./hardware-configuration.nix
  ];

  # Disable the systemd-boot EFI boot loader
  # It is now managed by Lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Lanzaboote
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  
  # Tell NixOS to decrypt before accessing LVM
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # Update kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable fwupd
  services.fwupd.enable = true;
  
  # Define hostname and enable networking
  networking.hostName = "complex";
  networking.networkmanager.enable = true;
  
  # Set time zone
  time.timeZone = "America/Denver";
  
  # Enable KDE desktop
  services.desktopManager.plasma6.enable = true;

  # Enable GNOME desktop
  # services.xserver = {
  #   enable = true;
  #   excludePackages = [ pkgs.xterm ];
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  #   xkb.layout = "us"; # Configure keymap in X11
  # };
  
  # Disable extra GNOME packages
  # environment.gnome.excludePackages = (with pkgs; [
  #   gnome-photos
  #   gnome-tour
  #   gnome-connections
  # ]) ++ (with pkgs.gnome; [
  #   cheese
  #   gnome-music
  #   epiphany
  #   geary
  #   evince
  #   gnome-characters
  #   totem
  #   tali
  #   iagno
  #   hitori
  #   atomix
  #   eog
  #   simple-scan
  #   yelp
  #   seahorse
  #   gnome-calculator
  #   gnome-calendar
  #   gnome-characters
  #   gnome-clocks
  #   gnome-contacts
  #   gnome-font-viewer
  #   gnome-logs
  #   gnome-maps
  #   gnome-music
  #   gnome-weather
  # ]);
  
  # Enable PipeWire
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable Wayland for Electron/Chromium
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Define a user account
  users.users.aleph = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  
  # Install packages
  environment.systemPackages = with pkgs; [
    git
    gh
    wget
    chromium
    vesktop
    heroic
    vscodium
    sbctl

    # Gnome extensions
    # gnomeExtensions.appindicator
  ];
  
  # Steam:tm:
  programs.steam = {
    enable = true;
  };
  
  # Allow unfree packages and WideVine
  nixpkgs.config = {
    allowUnfree = true;  
    chromium.enableWideVine = true;
  };
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Maybe don't change this right now
  system.stateVersion = "24.05";
}