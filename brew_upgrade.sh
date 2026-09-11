#!/bin/bash

brew update
brew upgrade

# Casks
casks=$(brew list --cask)

for cask in $casks; do
    brew upgrade --cask "$cask"
done

brew doctor
brew cleanup

