```
     ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
     ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
     ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
     ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
     ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
     ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝

                📜 ─────⚡────→ 📜  codex
               ╱
        (\__/) 
        (•ㅅ•)  📜 ─────⚡────→ 📜  copilot
        /づ  づ╲
                ╲
                 📜 ─────⚡────→ 📜  claude

             edit once, update everywhere
```

> _One repo to configure them all_ 🧙

One set of instructions, symlinked into **Codex**, **Copilot CLI**, and **Claude Code** — edit once, update everywhere. Plus some zsh goodies.

## What's Inside

```
  ┌──────┐
  │ ◈  ◈ │
  └──┬┬──┘
     ╘╘
```

| Path | Purpose |
|---|---|
| `instructions.md` | Universal coding instructions shared across all agents |
| `skills/` | Reusable agent skills (`clean-history`, `simplify`, …) |
| `zsh/` | Shell config + the `wt` worktree helper |
| `git/` | Global gitignore |

## Install
```sh
git clone <this-repo> ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh
```

Wires everything up via symlinks (existing files backed up to `*.bak`):

```
  🧙 casts symlink...
  ╭─────────────────────────────────────────────────╮
  │  instructions.md ──⚡──→ ~/.codex/AGENTS.md     │
  │                  ──⚡──→ ~/.copilot/...          │
  │                  ──⚡──→ ~/.claude/CLAUDE.md     │
  │  skills/*        ──⚡──→ ~/.{codex,copilot,claude}/skills/*  │
  │  zsh/            ──⚡──→ ~/.config/zsh           │
  │  git/ignore      ──⚡──→ core.excludesfile       │
  ╰─────────────────────────────────────────────────╯
```

Add a new skill? Drop a folder in `skills/`, re-run the installer. 🎯

## Worktree Helper (`wt`)
Spins up git worktrees with automatic symlinks (think `node_modules`) and `pnpm install` — ready to code instantly. 🏎️

```sh
wt add <branch>          # create worktree, symlink deps, install
wt rm [-d] [-f] <branch> # tear it down, optionally nuke the branch
```

Symlink patterns configured in `zsh/worktrees.symlinks`.

## Philosophy
- **DRY** — one file, many symlinks
- **Portable** — clone, install, done
- **Agent-agnostic** — works with whatever AI tools you throw at it
- **Non-destructive** — backs up before it overwrites