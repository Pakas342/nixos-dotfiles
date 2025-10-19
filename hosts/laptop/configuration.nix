# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Bootloader generation removal and garbage collection
  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pakas = {
    isNormalUser = true;
    description = "pakas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    ghostty
    kdePackages.dolphin
    zk
    firefox
    unzip
    slack
    claude-code
    yadm
    gcc
    nodejs
    nodePackages.markdownlint-cli2
    prettierd
    shopify-cli
    waybar
    wofi
    discord
    hyprpaper
    hyprshot
    adwaita-icon-theme
    gnome-themes-extra
    python3
    pinentry
    tldr
    fzf
    cacert
    glib
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Done as shopify might be requiring this to fricking work
  # It fucking was. it's related to node not finding the correct ssl certificates due to nixos different filesystem. I'll add the frequent ssl issues here so I don't have to fix it again
  environment.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";  # For Python, Ruby, etc.
    REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-bundle.crt";  # Python requests library
    CURL_CA_BUNDLE = "/etc/ssl/certs/ca-bundle.crt";  # For curl/wget
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.tmux.enable = true;

  programs.steam.enable = true;

  programs.hyprland.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Pakas342";
        email = "jcbp1999@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry;
  };

  programs.fish.enable = true;

  # GTK dark themes in apps
  programs.dconf.enable = true;

  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
        color-scheme = "prefer-dark";
        icon-theme = "Adwaita";
        cursor-theme = "Adwaita";
      };
    };
  }];

  # Program to solve a hydrogen cloudfare issue with nixos file structure
  programs.nix-ld.enable = true;
  # This is done to solve fixed route issues
  services.envfs.enable = true;

  # This is done to allow electron apps to ask for system permissions

  # enable wayland support for electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # XDG portals screen sharing
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

}
