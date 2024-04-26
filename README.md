# dotfiles

My personal dotfiles and useful bash scripts.

## Structure
TODO

## Installation
I use [GNU Stow](https://www.gnu.org/software/stow/) to manage the installation of my dotfiles. 

Dotfiles are stored with a 'dot-' prefix, then automatically symlinked to the correct location by Stow.
e.g.
```bash
'path/to/dotfiles_repo/dotfiles/dot-bashrc' -> '$HOME/.bashrc'
```

Stow is available from the package manager on modern Linux distros and via homebrew on MacOS. If you don't have `sudo` access, it [can also be installed into a Conda environment](https://github.com/conda-forge/stow-feedstock).


### Steps:
1. Run `make all`. This will back-up existing dotfiles under `~/.dotfile_backups` and replace them with symlinked versions from this repository.

Running `make test` will print out the file operations that will be performed as a check.

## Credits
My dotfiles are heavily inspired by:
1. https://github.com/mathiasbynens/dotfiles
2. https://github.com/holman/dotfiles

[This page](https://dotfiles.github.io/tutorials/) is a valuable starting point to learn more about dotfiles.
