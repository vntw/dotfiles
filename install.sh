#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# git pull origin master;
# git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

function hostname() {
  echo "Enter the hostname for this machine:"
	read hostname

	if [ -z "$hostname" ] ; then
	  echo "You must specify a hostname!"
	  exit 1
	fi

  echo "Setting the hostname to $hostname..."
	sudo scutil --set ComputerName $hostname
	sudo scutil --set HostName $hostname
	sudo scutil --set LocalHostName $hostname
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $hostname
}

function directories() {
  echo "Creating default directories..."
	mkdir -p ~/Development/Go
  mkdir -p ~/.ssh/
  mkdir -p ~/bin
}

function dotfiles() {
  echo "Installing dotfiles..."
	rsync --exclude ".git/" --exclude "_nosync/" --exclude ".DS_Store" --exclude "install.sh" --exclude "test.sh" --exclude "README.md" -avh --no-perms . ~;

  echo "Loading dotfiles..."
	source ~/.bash_profile;
}

function brew() {
  echo "Checking for Brew installation..."
  if [ -z "which brew" ] ; then
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

  hostname;

  directories;

  dotfiles;

  brew;

  echo "> Successfully installed!"
}

function helpmenu() {
  cat << EOF
Usage: ./install.sh [--only-dotfiles] [--help]

Without any options, this will perform multiple tasks:
  * Set the hostname
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

unset hostname;
unset directories;
unset dotfiles;
unset brew;
unset helpmenu;
unset install;
unset warning;
