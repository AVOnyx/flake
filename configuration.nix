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
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
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
  environment.systemPackages = (with pkgs; [
    git
    gh
    wget
    chromium
    vesktop
    heroic
    vscodium
    sbctl
  ]) ++ (with pkgs.kdePackages; [
    partitionmanager
  ]);
  
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