#!/bin/sh
brew install git
brew install imagemagick
brew install homebrew/versions/mysql56
brew install python
brew install rbenv
brew install redis
brew install ruby

# nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | $
source ~/.zshrc
nvm install 0.12
nvm install 4
nvm install 6
