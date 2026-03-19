#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CODEX_DIR="$HOME/.codex"
COPILOT_DIR="$HOME/.copilot"

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "  backing up $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -s "$src" "$dst"
  echo "  $dst → $src"
}

echo "=== Codex ==="
mkdir -p "$CODEX_DIR/skills"
link "$DOTFILES_DIR/instructions.md" "$CODEX_DIR/AGENTS.md"

for skill_dir in "$DOTFILES_DIR"/skills/*/; do
  skill="$(basename "$skill_dir")"
  link "$skill_dir" "$CODEX_DIR/skills/$skill"
done

echo "=== Zsh ==="
mkdir -p "$HOME/.config/zsh"

for zsh_file in "$DOTFILES_DIR"/zsh/*; do
  [ -e "$zsh_file" ] || continue
  link "$zsh_file" "$HOME/.config/zsh/$(basename "$zsh_file")"
done

echo "=== Copilot CLI ==="
mkdir -p "$COPILOT_DIR/skills"
link "$DOTFILES_DIR/instructions.md" "$COPILOT_DIR/copilot-instructions.md"

for skill_dir in "$DOTFILES_DIR"/skills/*/; do
  skill="$(basename "$skill_dir")"
  link "$skill_dir" "$COPILOT_DIR/skills/$skill"
done

echo "=== Claude Code ==="
mkdir -p "$HOME/.claude/skills"
link "$DOTFILES_DIR/instructions.md" "$HOME/.claude/CLAUDE.md"

for skill_dir in "$DOTFILES_DIR"/skills/*/; do
  skill="$(basename "$skill_dir")"
  link "$skill_dir" "$HOME/.claude/skills/$skill"
done

echo "=== Zshrc ==="
ZSHRC="$HOME/.zshrc"
SOURCE_BLOCK='for zsh_config in ~/.config/zsh/*.zsh(N); do
  source "$zsh_config"
done'

if ! grep -qF '~/.config/zsh/*.zsh' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' "$SOURCE_BLOCK" >> "$ZSHRC"
  echo "  appended sourcing loop to $ZSHRC"
else
  echo "  sourcing loop already present in $ZSHRC"
fi

echo "=== Git ==="
git config --global core.excludesfile "$DOTFILES_DIR/git/ignore"
echo "  core.excludesfile → $DOTFILES_DIR/git/ignore"

echo "Done!"
