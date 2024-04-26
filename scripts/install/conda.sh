#!/usr/bin/env bash
if [ ! -f "${HOME}/miniconda.sh" ]; then wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh; fi

bash ~/miniconda.sh -b -p $HOME/miniconda3