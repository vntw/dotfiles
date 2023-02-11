#!/usr/bin/env bash

set -eu

source helpers.sh

info "Installing rustup"

if hash rustup 2>/dev/null; then
    echo "rustup already installed"
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
