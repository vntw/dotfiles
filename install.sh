#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function directories() {
	echo "Creating default directories..."
	mkdir -p ~/Development/Go
	mkdir -p ~/.ssh/
	mkdir -p ~/bin
}

function dotfiles() {
	if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
		echo "Downloading Vundle.vim..."
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
		vim +PluginInstall +qall
	fi

	echo "Installing dotfiles..."
	rsync --exclude ".git/" --exclude "_nosync/" --exclude ".DS_Store" --exclude "install.sh" --exclude "test.sh" --exclude "README.md" -avh --no-perms . ~;

	echo "Loading dotfiles..."
	source ~/.bash_profile;
}

function homebrew() {
	echo "Checking for Brew installation..."
	command -v brew >/dev/null 2>&1

	if [ $? != 0 ] ; then
		echo "Installing Brew..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "Brew is already installed!"
	fi;

	echo "Updating and upgrading Brew packages..."
	brew update
	brew upgrade

	echo "Bundling Brewfile..."
	brew bundle --file=~/Brewfile

	brew cleanup

	if ! grep -Fxq "/usr/local/bin/bash" /etc/shells; then
		echo "Adding the new Bash shell to the known shells..."
		sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
		chsh -s /usr/local/bin/bash
	fi;
}

function warning() {
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Nn] ]]; then
		exit
	fi;
}

function install() {
	sudo -v

	directories;

	dotfiles;

	homebrew;

	echo "> Successfully installed!"
}

function helpmenu() {
	cat << EOF
Usage: ./install.sh [--only-dotfiles] [--help]

Without any options, this will perform multiple tasks:
  * Create default directories
  * Install dotfiles
  * Install and update brew with packages from the Brewfile

--only-dotfiles will (surprise) only install the dotfiles, nothing else.
EOF
}

[ "$USER" = "root" ] && abort "Run this as yourself, not root."

while [ ! $# -eq 0 ]
do
	case "$1" in
		--help | -h)
			helpmenu;
			exit
			;;
		--only-dotfiles)
			warning;
			dotfiles;
			exit
			;;
	esac
	shift
done

warning;
install;

unset directories;
unset dotfiles;
unset homebrew;
unset helpmenu;
unset install;
unset warning;
