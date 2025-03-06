#!/bin/bash

./scripts/dotfiles.sh backup
./scripts/dotfiles.sh prune
stow --verbose --target=${HOME} --dotfiles --no-folding --restow dotfiles/