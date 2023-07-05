# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  # Permitindo pacotes sem atualizações
  nixpkgs.config.permittedInsecurePackages = [ "python-2.7.18.6" "openssl-1.1.1u" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.gnome.games.enable = false;
  services.xserver.desktopManager.gnome.flashback.enableMetacity = true;
  programs.dconf.enable = true;
  services.flatpak.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Ativando o Xmonad
  services.xserver.windowManager.xmonad = {
     enable = true;
     enableContribAndExtras = true;
  };
  
  # Removendo alguns pacotes do Gnome
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
   cheese # webcam tool
   gnome-calendar
   gnome-clocks
   gnome-contacts
   gnome-weather
   gnome-maps
   gnome-music
   epiphany # web browser
   geary # email reader
   gnome-characters
   totem # video player
  ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
  };

  # Configure console keymap
   console = {
    packages=[ pkgs.terminus_font ];
    font="${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    keyMap = "br-abnt2";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Ativando o zsh
  programs.zsh = {
    enable = true;
  };
  # Configurando o oh-my-zsh
   programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "fzf"];
    theme = "agnoster";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jfreitas = {
    isNormalUser = true;
    description = "José Antônio";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  home-manager.users.jfreitas = { pkgs, ... }: {

 home.stateVersion = "23.05";
 home.packages = with pkgs;
    [ 
    zsh
    zsh-powerlevel10k
    ];
    programs.zsh = {
            enable = true;
            plugins = [
                    {
                    name = "powerlevel10k";
                    src = pkgs.zsh-powerlevel10k;
                    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
                    }
];
};
};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    adapta-gtk-theme
    arandr
    automake
    autorandr
    bash-completion
    bat
    brave
    bzip2
    cinnamon.folder-color-switcher
    cinnamon.nemo
    cinnamon.nemo-python
    cinnamon.nemo-fileroller
    curl
    dmenu
    dropbox
    dropbox-cli
    exa
    feh
    flameshot
    fzf
    fzf-zsh
    gimp-with-plugins
    git
    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
    gnome3.gnome-tweaks
    gparted
    gnome.adwaita-icon-theme
    haskellPackages.xmobar
    imagemagick
    img2pdf
    keepassxc
    libreoffice-fresh
    lxde.lxsession
    lxappearance
    meld
    neofetch
    neovim
    networkmanagerapplet
    nitrogen
    nix-zsh-completions
    nodejs
    ntfs3g
    numlockx
    p7zip
    pavucontrol
    pdftk
    picom
    python.pkgs.pip
    rsync
    slock
    sublime4
    tcl
    texlive.combined.scheme-full
    texstudio
    tk
    tldr
    trayer
    vlc
    vim
    volumeicon
    wget
    zathura
    zsh
    zsh-autocomplete
    zsh-autosuggestions
    zsh-completions
    zsh-fast-syntax-highlighting
    zsh-history-substring-search
    zsh-powerlevel10k
    zsh-syntax-highlighting
    xclip
    xdotool
  ];
  
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  
  # Ativando o onedrive
  services.onedrive.enable = true;
  
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  
  # Ativando o Dropbox
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # Instalando fontes
  fonts = {
    fonts = with pkgs; [
      anonymousPro
      dejavu_fonts
      fira-code
      fira-mono
      font-awesome
      inconsolata
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      ttf_bitstream_vera
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
	      monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
	      serif = [ "Noto Serif" "Source Han Serif" ];
	      sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
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
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  
  # Auto upgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Limpeza automática
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 8d";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
