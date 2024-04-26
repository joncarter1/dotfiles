test:
	./scripts/dotfiles.sh test
	stow --verbose --target=${HOME} --dotfiles --no-folding --simulate --restow dotfiles/
backup:
	./scripts/dotfiles.sh backup
symlinks:
	stow --verbose --target=${HOME} --dotfiles --no-folding --restow dotfiles/
all:
	./scripts/dotfiles.sh backup
	./scripts/dotfiles.sh prune
	stow --verbose --target=${HOME} --dotfiles --no-folding --restow dotfiles/
delete:
	stow --verbose --target=${HOME} --delete */
