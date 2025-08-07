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
    boot = {
        loader = {
            systemd-boot.enable = true;
            # systemd-boot.configurationLimit = 20;
            efi.canTouchEfiVariables = true;
            # Disables the first screen
            # timeout = 0;
        };

        initrd = {
            systemd.enable = true;
            verbose = false;
        };

        # Flicker free graphical bootloader 
        # with animated splach screen
        plymouth = {
            enable = true;
            theme = "dark_planet";
            themePackages = with pkgs; [
                # By default we would install all themes
                (adi1090x-plymouth-themes.override {
                    selected_themes = [ "dark_planet" ];
                })
            ];
        };

        # Enable "Silent Boot"
        consoleLogLevel = 0;
        kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
            # "fsck.mode=skip"
        ];
    };

    # GPU
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    # Bluetooth
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };

    services.blueman.enable = true;

    networking.hostName = "nixos"; # Define your hostname.
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.wireless.userControlled.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Oslo";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];

    # LACT AMD GPU CONTROLLER
    systemd.services.lactd = {
        description = "AMDGPU Control Daemon";
        enable = true;  
        serviceConfig = {
            ExecStart = "${pkgs.lact}/bin/lact daemon";
        };
        wantedBy = ["multi-user.target"];
    };


    # Display Manager (login screen)
    services.xserver.displayManager.gdm.enable = true;
    services.displayManager.sddm.enable = false;

    # Enable the GNOME Desktop Environment.
    services.xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "colemak";
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
    users.users.maloha = {
        isNormalUser = true;
        description = "Marius Hatland";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        packages = with pkgs; [
            #  thunderbird
        ];
    };

    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Experimental features to enable nix flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Hyperland compositor
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    xdg.portal.enable = true;
    # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        vim
        git
        kitty # Terminal emulator
        alacritty # Terminal emulator
        home-manager # For managing .config files
        tree

        # APPLICATIONS
        pavucontrol # Sound control
        spotify
        teams-for-linux # Microsoft teams
        lazygit # Git terminal ui
        lazydocker # Docker terminal ui
        vscode
        imagemagick
        gimp
        zotero
        obsidian
        steam
        discord
        rpi-imager
        zoom-us
        tmux
        slumber

        # LANGUAGES
        #
        # PYTHON
        (python312.withPackages (ps: with ps; [
            pip ipykernel jupyter notebook
        ]))
        # python312Packages.ipython
        # python312Packages.ipykernel
        # python312Packages.jupyter
        # python312Packages.notebook
        # pipenv
        # poetry
        # python3Packages.setuptools
        # python3Packages.wheel
        gcc
        glibc
        glibc.dev
        gcc-unwrapped # Needed for libstdc in python
        stdenv.cc.cc.lib
        nodejs
        texlive.combined.scheme-full

        #For opencv-python
        mesa
        libglvnd

        # NEOVIM
        neovim
        xclip # Needed to access clipboard in neovim
        ripgrep # Live grep for telescope
        fd # Find files for telescope
        fzf # Fuzzy finder

        # Needed for LSP (mason)
        curl
        unzip
        wget
        gzip
        nodejs
        cargo
        cmake
        jq

        # HYPRLAND
        hyprpaper # For setting backgrounds in hyprland
        wayland # Application menu
        wofi # Application menu
        waybar # Status bar in hyprland
        dunst # Notification daemon
        libnotify # Also notification daemon. Not sure if needed?
        swww # Animated wallpaper daemon
        xdg-desktop-portal-hyprland
        # xdg-desktop-portal-gtk
        wlogout # Logout manager
        hyprlock # Screen locker
        swaylock-effects # Screen locker
        qt6ct
        wl-clipboard # Wayland clipboard
        cliphist # Clipboard manager
        hyprshot # Screenshot program
        brightnessctl # Brightness adjuster
    ];

    # Fonts
    fonts.packages = with pkgs; [
        font-awesome
        powerline-fonts
        powerline-symbols
        nerd-fonts.jetbrains-mono
    ];

    # Setting zsh as default shell
    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;
    programs.nix-ld.enable = true;


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

    # Enable virtualbox
    virtualisation.virtualbox.host.enable = true;


    virtualisation.docker = {
        enable = true;
    };
    users.extraGroups.vboxusers.members = [ "maloha" ];

    # DOTNET DEV CERTIFICATE
    security.pki.certificates = [
        ''
        -----BEGIN CERTIFICATE-----
        MIIDDTCCAfWgAwIBAgIJAOQ6xX5XyJ08MA0GCSqGSIb3DQEBCwUAMBQxEjAQBgNV
        BAMTCWxvY2FsaG9zdDAeFw0yNDExMTUxNDE3NTRaFw0yNTExMTUxNDE3NTRaMBQx
        EjAQBgNVBAMTCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
        ggEBALVLxNmxXyeum48xAz+ks/aksOxbd/E3VuvNkSRf8YsSu/A9PxLAU4D3mhiN
        0rDn3vkLejto6vSb7J/pNBVLvZVKVy6dbOm/3eWfZPhrRQRKxQ4pxTOogruTZeP4
        pMIxzWF8MMQ79/Cn1dCRY3kmttP/NQ6O20GYU5aAGASGYZWrBI0T5K7HFsfo1zyv
        ciOJkDEkSft+kU0h8cJCY8TyVs0fq28WvJcka4zb1wdYLwajLeIDAqBT15Qj5zoF
        PfKYAc+6flajUsOD8ysUzNdftG4ygUGyCEw9cn42LKB8rc7dZPrEVQV0fy7wflcb
        PHI3rtlFznXGKS4/c2mACmgyTk8CAwEAAaNiMGAwDAYDVR0TAQH/BAIwADAOBgNV
        HQ8BAf8EBAMCBaAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwEwFwYDVR0RAQH/BA0w
        C4IJbG9jYWxob3N0MA8GCisGAQQBgjdUAQEEAQIwDQYJKoZIhvcNAQELBQADggEB
        AD/sxVn+bOG1SdMsIOnBq+guKLiIoux2GHVNdUrYJg+kqVB3phdCyYVbagQKuGap
        /II8uwuOt70qzXIZ4MlzzN28BwBm3drCyXqE3ibg5E1TMwLYdgZuFY00R0QwW0Ux
        dg579JWl2hD4Hre5s6jh2G2LUtpwN3OrS6XTc8SDuIwzOkGXLMtCT+QgjMX1+i4s
        fvFJbH5BF+gkK+kIbGbcxiAr1QCpxggBR9aOBTNodab3sM2E5glnptOeW44Qs9zk
        Y8corw0GzK+lCAZ5YuEaTg6riz3ywaNtczkqHtnNMZZ/4I03WIUXhZd42Q+Dac20
        SbOTq6KMlQT82cilE0YdAt4=
        -----END CERTIFICATE-----
        ''
    ];


    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?

}
