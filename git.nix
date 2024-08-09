{ config, pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  programs.git.userName = "maloha7";
  programs.git.userEmail = "marius.hatland@gmail.com";
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    safe.directory = [ ("/home/" + "maloha" + "/.dotfiles")
                       ("/home/" + "maloha" + "/.dotfiles/.git") ];
  };
}
