{ config, pkgs, ... }:

{ 
  programs.zsh = {
        enable = true;
        shellAliases = {
                v = "nvim";
                ls = "eza --icons -T -L=1";
                cat = "bat";
		".." = "cd ..";
        };
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        autocd = true;

        oh-my-zsh = {
                enable = true;
                theme = "cloud";
                plugins = [ "sudo" ];
        };
  };

  programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
  };

  home.packages = with pkgs; [
	neofetch # For fecthing system info
	bat # Improved cat
	eza # Improved ls
  ];
}
