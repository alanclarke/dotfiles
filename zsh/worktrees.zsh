_wt_resolve_context() {
  local developer_root="${1%/}"
  local worktrees_root="${2%/}"
  local require_source_dir="${3:-0}"
  local common_dir git_dir top_level repo repo_handle repo_source_dir current_dir

  if git rev-parse --git-dir >/dev/null 2>&1; then
    common_dir="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || return 1
    git_dir="$(git rev-parse --path-format=absolute --git-dir 2>/dev/null)" || return 1

    if [[ "$(git rev-parse --is-bare-repository 2>/dev/null)" == "true" ]]; then
      repo="$(basename "$common_dir")"
      repo="${repo%.git}"
    elif [[ "$(basename "$common_dir")" == ".git" ]]; then
      repo="$(basename "$(dirname "$common_dir")")"
      repo="${repo%.git}"
    elif [[ "$common_dir" != "$git_dir" || "$common_dir" == *.git ]]; then
      repo="$(basename "$common_dir")"
      repo="${repo%.git}"
    else
      top_level="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
      repo="$(basename "$top_level")"
      repo="${repo%.git}"
    fi

    if [[ -d "$developer_root/$repo.git" ]]; then
      repo_handle="$developer_root/$repo.git"
    elif [[ "$common_dir" == *.git ]]; then
      repo_handle="$common_dir"
    else
      repo_handle="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
    fi
  else
    current_dir="${PWD:A}"

    if [[ "${current_dir:h}" != "$worktrees_root" ]]; then
      echo "error: run this from inside a git repo, bare repo, worktree, or $worktrees_root/<repo>"
      return 1
    fi

    repo="${current_dir:t}"
    repo_handle="$developer_root/$repo.git"
    repo_source_dir="$developer_root/$repo"

    if [[ ! -d "$repo_handle" ]]; then
      echo "error: expected bare repo not found: $repo_handle"
      return 1
    fi

    if [[ "$require_source_dir" -eq 1 && ! -d "$repo_source_dir" ]]; then
      echo "error: expected source repo not found: $repo_source_dir"
      return 1
    fi
  fi

  typeset -g WT_REPO="$repo"
  typeset -g WT_REPO_HANDLE="$repo_handle"
  typeset -g WT_REPO_SOURCE_DIR="${repo_source_dir:-$developer_root/$repo}"
}

_wt_git() {
  if [[ "$WT_REPO_HANDLE" == *.git ]]; then
    git --git-dir="$WT_REPO_HANDLE" "$@"
    return
  fi

  git -C "$WT_REPO_HANDLE" "$@"
}

_wt_refresh_source_head() {
  local current_branch

  current_branch="$(git -C "$WT_REPO_SOURCE_DIR" branch --show-current 2>/dev/null)"

  if [[ -z "$current_branch" ]]; then
    echo "error: expected $WT_REPO_SOURCE_DIR to be checked out on a branch"
    return 1
  fi

  git -C "$WT_REPO_SOURCE_DIR" pull --ff-only >&2 || return 1

  if [[ "$WT_REPO_HANDLE" == "$WT_REPO_SOURCE_DIR" ]]; then
    print -r -- "HEAD"
    return 0
  fi

  _wt_git fetch "$WT_REPO_SOURCE_DIR" "$current_branch" >&2 || return 1

  print -r -- "FETCH_HEAD"
}

_wt_add() {
  local branch
  local developer_root="${DEVELOPER_ROOT:-$HOME/Developer}"
  local worktrees_root="${WORKTREES_ROOT:-$developer_root/worktrees}"
  local symlink_patterns_file="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/worktrees.symlinks"
  local base_ref
  local worktree_dir

  if [[ "$1" == "git" && ( "$2" == "checkout" || "$2" == "switch" ) ]]; then
    shift 2
    if [[ "$1" == "-b" || "$1" == "-c" ]]; then
      shift
    fi
    branch="$1"
  else
    branch="$1"
  fi

  if [[ -z "$branch" ]]; then
    echo "usage: wt add <branch | git checkout -b <branch> | git switch -c <branch>>"
    return 2
  fi

  _wt_resolve_context "$developer_root" "$worktrees_root" 1 || return 1
  base_ref="$(_wt_refresh_source_head)" || return 1

  worktree_dir="$worktrees_root/$WT_REPO/$branch"

  if [[ -e "$worktree_dir" ]]; then
    echo "error: $worktree_dir already exists"
    return 1
  fi

  mkdir -p "$worktrees_root/$WT_REPO" || return 1

  if _wt_git rev-parse --verify --quiet "$branch" >/dev/null; then
    _wt_git worktree add "$worktree_dir" "$branch" || return 1
  else
    _wt_git worktree add "$worktree_dir" -b "$branch" "$base_ref" || return 1
  fi

  if [[ -d "$WT_REPO_SOURCE_DIR" ]]; then
    local src rel dest pattern linked_any=0
    typeset -A linked_paths

    if [[ -f "$symlink_patterns_file" ]]; then
      while IFS= read -r pattern || [[ -n "$pattern" ]]; do
        [[ -n "$pattern" ]] || continue
        [[ "$pattern" == \#* ]] && continue

        while IFS= read -r -d '' src; do
          [[ -z "$src" || -n "${linked_paths[$src]}" ]] && continue
          rel="${src#$WT_REPO_SOURCE_DIR/}"
          if git -C "$WT_REPO_SOURCE_DIR" ls-files --error-unmatch "$rel" >/dev/null 2>&1; then
            continue
          fi
          linked_paths[$src]=1
          dest="$worktree_dir/$rel"
          mkdir -p "$(dirname "$dest")" || return 1
          ln -sfn "$src" "$dest" || return 1
          linked_any=1
        done < <(
          if [[ "$pattern" == */* ]]; then
            find "$WT_REPO_SOURCE_DIR" \
              \( -type f -o -type l \) \
              -path "$WT_REPO_SOURCE_DIR/$pattern" \
              -not -path '*/.git/*' \
              -not -path '*/node_modules/*' \
              -print0
          else
            find "$WT_REPO_SOURCE_DIR" \
              \( -type f -o -type l \) \
              -name "$pattern" \
              -not -path '*/.git/*' \
              -not -path '*/node_modules/*' \
              -print0
          fi
        )
      done < "$symlink_patterns_file"
    fi

    echo "created $worktree_dir"
    if [[ "$linked_any" -eq 1 ]]; then
      echo "linked files from $WT_REPO_SOURCE_DIR using $symlink_patterns_file"
    elif [[ -f "$symlink_patterns_file" ]]; then
      echo "note: no matching files found for patterns in $symlink_patterns_file"
    else
      echo "note: symlink patterns file not found: $symlink_patterns_file"
    fi
  else
    echo "created $worktree_dir"
    echo "note: $WT_REPO_SOURCE_DIR does not exist"
  fi

  builtin cd "$worktree_dir" || return 1

  if [[ -f "pnpm-lock.yaml" ]]; then
    echo "running pnpm install in $worktree_dir"
    pnpm install || return 1
  fi
}

_wt_rm() {
  local branch
  local developer_root="${DEVELOPER_ROOT:-$HOME/Developer}"
  local worktrees_root="${WORKTREES_ROOT:-$developer_root/worktrees}"
  local worktree_dir delete_branch=0 force=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d|--delete-branch) delete_branch=1 ;;
      -f|--force) force=1 ;;
      *) branch="$1" ;;
    esac
    shift
  done

  if [[ -z "$branch" ]]; then
    echo "usage: wt rm [--delete-branch|-d] [--force|-f] <branch>"
    return 2
  fi

  _wt_resolve_context "$developer_root" "$worktrees_root" 0 || return 1

  worktree_dir="$worktrees_root/$WT_REPO/$branch"

  if [[ ! -d "$worktree_dir" ]]; then
    echo "error: worktree not found: $worktree_dir"
    return 1
  fi

  if [[ "$force" -eq 1 ]]; then
    _wt_git worktree remove --force "$worktree_dir" || return 1
  else
    _wt_git worktree remove "$worktree_dir" || return 1
  fi

  if [[ "$delete_branch" -eq 1 ]]; then
    _wt_git branch -d "$branch"
  fi

  echo "removed $worktree_dir"
}

wt() {
  local command="$1"

  case "$command" in
    add)
      shift
      _wt_add "$@"
      ;;
    rm|remove)
      shift
      _wt_rm "$@"
      ;;
    ""|-h|--help|help)
      echo "usage: wt <add|rm> ..."
      echo "  wt add <branch | git checkout -b <branch> | git switch -c <branch>>"
      echo "  wt rm [--delete-branch|-d] [--force|-f] <branch>"
      return 2
      ;;
    *)
      echo "error: unknown wt command: $command"
      echo "usage: wt <add|rm> ..."
      return 2
      ;;
  esac
}

wtadd() {
  _wt_add "$@"
}

wtrm() {
  _wt_rm "$@"
}
