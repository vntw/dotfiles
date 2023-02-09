#!/usr/bin/env bash

set -eu

[ "$USER" = "root" ] && abort "Run this as yourself, not root."

DIR="$(cd `dirname $0` && pwd)"
cd "$DIR"

function info() {
	echo -e "\n\033[0;32m➤ $1\033[0m"
}

function is_mac() {
	[[ $(uname -s) == Darwin* ]]
}

function is_linux() {
	[[ $(uname -s) == Linux* ]]
}

function directories() {
	info "Creating default directories…"

	mkdir -p ~/bin ~/dev/go ~/.gnupg ~/.ssh
	chmod 0700 ~/.gnupg ~/.ssh
}

function dotfiles() {
	info "Linking dotfiles…"

	for f in $(find "$DIR/home" -type f) ; do
		echo "$f to ~/${f#"$DIR/home/"}"
		ln -sF "$f" ~/${f#"$DIR/home/"}
	done
}

function mac_app_settings() {
	info "Linking app settings…"

	mkdir -p ~/Library/Application\ Support/
	cle
	ln -sF $DIR/settings/spectacle/shortcuts.json ~/Library/Application\ Support/Spectacle/Shortcuts.json

	mkdir -p ~/Library/Application\ Support/Code/User
	ln -sF $DIR/settings/vscode/*.json ~/Library/Application\ Support/Code/User/

	mkdir -p ~/Library/Containers/com.if.Amphetamine/Data/Library/Preferences
	cp $DIR/settings/amphetamine/com.if.Amphetamine.plist ~/Library/Containers/com.if.Amphetamine/Data/Library/Preferences/com.if.Amphetamine.plist
}

function mac_settings() {
	info "Applying macOS settings…"
	./mac-settings.sh
}

function vscode_extensions() {
	info "Installing VSCode extensions…"
	./vscode-extensions.sh
}

function homebrew() {
	info "Installing Brew…"

	if hash brew 2>/dev/null; then
		echo "Brew already installed"
		return
	else
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi;

	info "Bundling Brewfile…"
	brew bundle --file=./Brewfile
	brew cleanup

	# change shell to updated brew zsh
	local shell_path="/usr/local/bin/zsh"
	info "Changing shell to '$shell_path'"
	if [ $SHELL != $shell_path ]; then
		if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
			sudo sh -c "echo $shell_path >> /etc/shells"
		fi
		chsh -s "$shell_path"
	fi
}

function zsh() {
	info "Setting up zsh"

	if [ -d ~/.oh-my-zsh ]; then
		echo "oh-my-zsh already installed"
		return
	fi

	git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
	curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf -o ~/Library/Fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete.ttf
	curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf -o ~/Library/Fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono.ttf

	info "Installing nvm, execute 'nvm install x && npm i -g yarn' later"
	git clone --depth=1 https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
}

function priv_repo() {
	info "Installing \033[0;31mprivate\033[32m repository"

	if [ ! -d ~/.dotfiles-private ]; then
		git clone git@github.com:vntw/dotfiles-private.git ~/.dotfiles-private
	else
		echo "Repository already checked out"
	fi

	~/.dotfiles-private/install.sh
}

function install() {
	sudo -v

	priv_repo;
	directories;
	homebrew;
	dotfiles;
	zsh;

	if is_mac
	then
		mac_app_settings;
		mac_macos;
	fi

	vscode_extensions;

	success;
}

function links_only() {
	if is_mac
	then
		settings_mac;
	fi

	priv_repo;
	dotfiles;
	success;
}

function success() {
	info "Successfully installed!"
}

function help_menu() {
	cat << EOF
Usage: ./install.sh [--help|-h] [--only-links]

--only-links Only create symlinks for settings/public/private repo
EOF
}

while [ ! $# -eq 0 ]
do
	case "$1" in
		--help | -h)
			help_menu;
			exit
			;;
		--only-links)
			links_only;
			exit
			;;
	esac
	shift
done

install;

unset success;
unset links_only;
unset priv_repo;
unset directories;
unset macos;
unset dotfiles;
unset zsh;
unset homebrew;
unset help_menu;
unset install;
unset info;
unset is_mac;
unset is_linux;
