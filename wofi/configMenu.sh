#!/usr/bin/env bash
#
# Script name: dmconf
# Description: Choose from a list of configuration files to edit.
# Dependencies: dmenu
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# Contributors: Derek Taylor

# Defining the text editor to use.
# DMENUEDITOR="vim"
# DMENUEDITOR="nvim"
# DMEDITOR="st -e nvim"
MYEDITOR="alacritty -e nvim"

# An array of options to choose.
# You can edit this list to add/remove config files.
declare -A options
options[ Alacritty]="$HOME/.dotfiles/alacritty.toml"
options[ Configuration]="$HOME/.dotfiles/configuration.nix"
options[ Hyprland]="$HOME/.dotfiles/hyprland.conf"
options[ Home-Manager]="$HOME/.dotfiles/home.nix"

# Piping the above array into dmenu.
# We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${!options[@]}" | wofi -d -i 20 -p 'Edit config:')
# $menu = wofi --show drun --allow-images --style ~/.config/wofi/style.css --hide-scroll --width 550 --height 300

# What to do when/if we choose a file to edit.
if [ "$choice" ]; then
	conf=$(printf '%s\n' "${options["${choice}"]}")
	$MYEDITOR "$conf"
# What to do if we just escape without choosing anything.
else
	echo "Program terminated." && exit 0
fi
