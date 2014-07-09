#!/usr/bin/env bash

# remove unused packages - check carefully
sudo pacman -Rsn $(pacman -Qdtq)

# pacman cache clean up
sudo pacman -Sc

sudo pacman-optimize && sudo sync
