# dotfiles

My personal dotfiles and useful bash scripts.

## Installation
I use [GNU Stow](https://www.gnu.org/software/stow/) to manage the installation of my dotfiles.
This is available from the package manager on modern Linux distros.
If you don't have `sudo` access, it can also be installed into a Conda environment:
https://github.com/conda-forge/stow-feedstock

Dotfiles are stored with a 'dot-' prefix, then symlinked to the correct location by Stow.
e.g. 'bash/dot-bashrc' -> '$HOME/.bashrc'.

Installation steps:
1. `make all`.

## Credits
My configuration draws heavily on: https://github.com/mathiasbynens/dotfiles

[This page](https://dotfiles.github.io/tutorials/) is a valuable starting point to learn more about dotfiles.
