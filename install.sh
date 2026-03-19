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
link "$DOTFILES_DIR/codex/AGENTS.md" "$CODEX_DIR/AGENTS.md"

for skill_dir in "$DOTFILES_DIR"/codex/skills/*/; do
  skill="$(basename "$skill_dir")"
  link "$skill_dir" "$CODEX_DIR/skills/$skill"
done

echo "=== Copilot CLI ==="
mkdir -p "$COPILOT_DIR"
link "$DOTFILES_DIR/codex/AGENTS.md" "$COPILOT_DIR/copilot-instructions.md"

echo "Done!"
