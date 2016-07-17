#!/bin/sh

# git
echo ' - What is your github username?'
read -e USERNAME
echo ' - What is your github email?'
read -e EMAIL
git config --global user.name $USERNAME
git config --global user.email $EMAIL

touch ~/.gitignore
echo "node_modules" >> ~/.gitignore
echo ".DS_Store" >> ~/.gitignore
echo "*.pyc" >> ~/.gitignore
git config --global core.excludesfile ~/.gitignore
