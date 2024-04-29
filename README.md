# dotfiles

My personal dotfiles and useful bash scripts.

## Contents
```
└───scripts
│   └───install # Common installs e.g. miniconda, fzf, zoxide
│   └───slurm   # Slurm utilities e.g. setting up VSCode on a compute node.
└───dotfiles    # Dotfiles: .bashrc, .tmux.conf, .aliases etc.
```

## Installation
I use [GNU Stow](https://www.gnu.org/software/stow/) to manage the installation of my dotfiles. 

Dotfiles are stored with a 'dot-' prefix, then automatically symlinked to the correct location by Stow.
e.g.
```bash
'path/to/dotfiles_repo/dotfiles/dot-bashrc' -> '$HOME/.bashrc'
```

Stow is available from the package manager on modern Linux distros and via homebrew on MacOS. If you don't have `sudo` access, it [can also be installed into a Conda environment](https://github.com/conda-forge/stow-feedstock).


### Steps:
1. `make all`. Backs up existing dotfiles under `~/.dotfile_backups` and replaces them with symlinked versions from this repository.

Running `make test` prints out the file operations that will be performed as a check.

n.b. I would not recommend naively installing these dotfiles unless you fully understand what they do.</br>
Instead, I'd recommend using them (and the examples listed below) to gradually build up your own personal set.

## Credits
My dotfiles are heavily inspired by:
1. https://github.com/mathiasbynens/dotfiles
2. https://github.com/holman/dotfiles

[This page](https://dotfiles.github.io/tutorials/) is a valuable starting point to learn more about dotfiles.
