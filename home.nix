{ config, pkgs, ... }:

{
  imports = [
	./sh.nix
    ./git.nix
  ];


  # Home Manager needs a bit of informa:tion about you and the paths it should
  # manage.
  home.username = "maloha";
  home.homeDirectory = "/home/maloha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/maloha/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";


    # Force apps to use wayland
    NIXOS_OZONE_WL=1;

    GTK_THEME = "Catpuccin-Macchiato";
    XDG_CURRENT_DESKTOP = "Hyprland";
    LD_LIBRARY_PATH= "${pkgs.stdenv.cc.cc.lib}/lib/"; # Remove if nix breaks :)
  };

  ### THEME ###
  catppuccin = {
        enable = true;
        flavor = "macchiato";
        pointerCursor = {
            enable = true;
            accent = "teal";
            flavor = "macchiato";
        };
    };
  
  gtk = {
        enable = true;
        catppuccin = {
        enable = true;
        flavor = "macchiato";
        gnomeShellTheme = true;
    };
  };

  # Puts the config files from .dotfiles into .config
  home.file = {
	".config/hypr/hyprland.conf".source = ./hyprland.conf;
	".config/alacritty/alacritty.toml".source = ./alacritty.toml;
	".config/nvim" = {
		source = ./nvim;
		recursive = true;
	};
	".config/hypr" = {
		source = ./hypr;
		recursive = true;
	};
	".config/wlogout" = {
		source = ./wlogout;
		recursive = true;
	};
	".config/swaylock" = {
		source = ./swaylock;
		recursive = true;
	};
	".config/waybar" = {
		source = ./waybar;
		recursive = true;
	};
	".config/xdg-desktop-portal" = {
		source = ./xdg-desktop-portal;
		recursive = true;
	};
	".config/wofi" = {
		source = ./wofi;
		recursive = true;
	};
	".config/dunst" = {
		source = ./dunst;
		recursive = true;
	};
  };

  services.hyprpaper = {
  	package = pkgs.hyprpaper;
  	enable = true;
	settings = {
		  ipc = "on";
		  splash = false;
		  splash_offset = 2.0;

		  preload =
		    [ "~/.dotfiles/wallpapers/coffee.gif" ];

		  wallpaper = [
		    "DP-1,~/.dotfiles/wallpapers/zen.jpg"
		  ];
	};
  };

  # Enables starship which ensures a fast prompt in the shell
  programs.starship.enable = true;

  # PDF viewer
  programs.zathura.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
