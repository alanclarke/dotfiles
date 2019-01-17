#!/bin/sh
echo 'installing brew...'

# install brew
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew upgrade
brew cleanup

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# utils
brew cask install 1password
brew cask install daisydisk
brew cask install dropbox
brew cask install sequel-pro
brew cask install spectacle
brew cask install viscosity

# browsers
brew cask install firefox
brew cask install google-chrome
brew cask install opera
brew cask install torbrowser

# dev
brew cask install iterm2
brew cask install virtualbox

# editors
brew cask install atom
brew cask install sublime-text

# fun
brew cask install slack
brew cask install spotify
brew cask install vlc
