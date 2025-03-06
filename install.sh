#!/bin/bash

# Install dotfiles
./scripts/dotfiles.sh backup
./scripts/dotfiles.sh prune
stow --verbose --target=${HOME} --dotfiles --no-folding --restow dotfiles/

# Install fzf
./scripts/install/fzf.sh