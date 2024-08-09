# Updating the system

1. Update flake packages:

nix flake update

2. Update the system (While in .dotfiles directory):

sudo nixos-rebuild switch --flake .


