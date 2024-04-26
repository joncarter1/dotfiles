#!/bin/bash

if [ -z "$1" ]; then
    echo "You need to provide a run mode for this script. Either 'test' (print out what will happen), 'backup' (perform backup), or 'prune' (remove existing files)."
    exit 1
elif [ "$1" == "test" ]; then
    echo "Running in test mode. Operations will be printed but not executed."
elif [ "$1" == "backup" ]; then
    echo "Backing up dotfiles...."
elif [ "$1" == "prune" ]; then
    echo "Removing existing dotfiles not managed by Stow..."
else
    echo "Run mode was neither 'test' (print what will happen), 'prune' (deleted existing files) or 'backup' (perform backup)"
    exit 1
fi
MODE="${1}"

if [[ -d "dotfiles" ]]; then
    DOTFILES_DIR="$(pwd)/dotfiles"
else
    echo "Couldn't locate dotfiles folder within current directory. This script should be run from the top level of the repository."
    exit 1
fi
BACKUP_DIR="${HOME}/.dotfile_backups/$(date +%Y-%m-%d-%H-%M-%S)"


# A function to handle directory traversal and backing up of files as needed
function modify_dotfiles() {
    # Iterating over all items in the current directory
    find "$DOTFILES_DIR" -mindepth 1 -type f | while IFS= read -r src_file; do
        # Constructing the target file path by removing DOTFILES_DIR part, replacing 'dot-' with '.', and prefixing with target directory
        local relative_path="${src_file#$DOTFILES_DIR/}"  # Remove base DOTFILES_DIR path
        local target_path="${relative_path/'dot-'/.}"  # Replace 'dot-' prefix with '.'
        target_path="$HOME/${target_path#/}"  # Construct full target path
        local target_relative_path="${target_path#$HOME/}"  # Replace 'dot-' prefix with '.'
        # If the target file exists and isn't a symlink, back it up
        if [[ $(readlink -f $target_path) != $target_path ]]; then
            echo "Skipping symlink $target_path. Assuming this is already managed by Stow."
        elif [[ -e "$target_path" ]]; then
            local backup_file="$BACKUP_DIR/${target_relative_path}"
            if [[ ${MODE} == "test" ]]; then
                echo "Backup up of $target_path will be stored at $backup_file."
                echo "$backup_file will be deleted."
            elif [[ ${MODE} == "backup" ]]; then
                echo "Backing up $target_path at $backup_file"
                mkdir -p "$(dirname "$backup_file")"
                cp "$target_path" "$backup_file"
            elif [[ ${MODE} == "prune" ]]; then   
                echo "Removing $target_path"
                rm -f $target_path
            fi
        fi
    done
}

modify_dotfiles

if [[ ${MODE} == "test" ]]; then
    echo "Done."
elif [[ ${MODE} == "backup" ]]; then
    echo "Done. Files, if any, are backed up to $BACKUP_DIR"
elif [[ ${MODE} == "prune" ]]; then   
    echo "Pruned files."
fi

