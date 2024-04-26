#!/bin/bash

# Directories definition
DOTFILES_DIR="${HOME}/code/dotfiles"
BACKUP_DIR="${HOME}/.dotfile_backups/$(date +%Y-%m-%d-%H-%M-%S)"

# A function to handle directory traversal and backing up of files as needed
backup_and_link() {
    local src_dir=$1  # Source directory being processed
    local target_prefix=$2  # Target directory prefix, in this case, the home directory

    # Iterating over all items in the current directory
    find "$src_dir" -mindepth 2 -type f | while IFS= read -r src_file; do
        # Constructing the target file path by removing DOTFILES_DIR part, replacing 'dot-' with '.', and prefixing with target directory
        local relative_path="${src_file#$DOTFILES_DIR/}"  # Remove base DOTFILES_DIR path
        local target_path="${relative_path/'dot-'/.}"  # Replace 'dot-' prefix with '.'
        target_path="$target_prefix/${target_path#*/}"  # Construct full target path
        local target_relative_path="${target_path#$HOME/}"  # Replace 'dot-' prefix with '.'
        echo $target_path
        echo $relative_path
        echo $target_relative_path
        # If the target file exists, back it up
        if [ -e "$target_path" ]; then
            local backup_file="$BACKUP_DIR/${target_relative_path}"
            #backup_file=${backup_file//\//-}  # Replace forward slashes with hyphens for the backup file path

            echo "Backing up $target_path to $backup_file"
            #mkdir -p "$(dirname "$backup_file")"
            #mv "$target_path" "$backup_file"
        fi
    done
}

# Starting from the base of DOTFILES_DIR
backup_and_link "$DOTFILES_DIR" "$HOME"

echo "Backup complete. Files, if any, are backed up to $BACKUP_DIR"