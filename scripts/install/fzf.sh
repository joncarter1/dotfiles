#!/usr/bin/env bash

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash