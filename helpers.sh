#!/usr/bin/env bash

set -eu

function info() {
	echo -e "\n\033[0;32m➤ $1\033[0m"
}

function is_intel_mac() {
	[[ $(uname -m) == x86_64 ]] && is_mac
}

function is_m_mac() {
	[[ $(uname -m) == arm64 ]] && is_mac
}

function is_mac() {
	[[ $(uname -s) == Darwin* ]]
}

function is_linux() {
	[[ $(uname -s) == Linux* ]]
}
