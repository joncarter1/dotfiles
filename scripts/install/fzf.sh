#!/usr/bin/env bash

if [ -d ~/.fzf ]; then
  git -C ~/.fzf pull
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi
~/.fzf/install --all --no-update-rc
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash