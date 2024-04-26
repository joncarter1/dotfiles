all:
	stow --verbose --target=${HOME} --dotfiles --no-folding --restow dotfiles/
delete:
	stow --verbose --target=${HOME} --delete */
