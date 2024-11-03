#!/bin/bash

# Define directories to be cleared
CACHE_DIRS=(
    "$HOME/.local/share/nvim"
    "$HOME/.cache/nvim"
)

# Iterate over the directories and remove them if they exist
for dir in "${CACHE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "Removing: $dir"
        rm -rf "$dir"
    else
        echo "Directory not found: $dir"
    fi
done

echo "Neovim cache cleanup complete."

