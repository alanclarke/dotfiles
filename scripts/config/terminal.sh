#!/bin/sh

# zsh
brew install zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
sed -e 's/ZSH_THEME=.*/ZSH_THEME=\"simple\"/g' ~/.zshrc

# editor
git config --global core.editor nano
echo "export EDITOR=nano" >> ~/.zshrc
