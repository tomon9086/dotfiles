DOTFILES_PATH="${0:a:h}"

case "$OSTYPE" in
  darwin*) DOTFILES_OS="macos" ;;
  linux*)  DOTFILES_OS="linux" ;;
esac

# Helper: source <OS>.zsh then common.zsh from a directory
if [[ -n "${DOTFILES_DEBUG:-}" ]]; then
  zmodload zsh/datetime
  _source_os() {
    local dir="$1" f
    for f in "$dir/${DOTFILES_OS}.zsh" "$dir/common.zsh"; do
      [[ -f "$f" ]] || continue
      local t0=$EPOCHREALTIME
      source "$f"
      printf '[dotfiles] %5.0fms  %s\n' "$(( (EPOCHREALTIME - t0) * 1000 ))" "${f#${DOTFILES_PATH}/}" >&2
    done
  }
else
  _source_os() {
    local dir="$1"
    [[ -f "$dir/${DOTFILES_OS}.zsh" ]] && source "$dir/${DOTFILES_OS}.zsh"
    [[ -f "$dir/common.zsh" ]] && source "$dir/common.zsh"
  }
fi

_source_os "$DOTFILES_PATH/zsh/alias"
_source_os "$DOTFILES_PATH/zsh/completion"
_source_os "$DOTFILES_PATH/zsh/editor"
_source_os "$DOTFILES_PATH/zsh/function"
_source_os "$DOTFILES_PATH/zsh/ghq"
_source_os "$DOTFILES_PATH/zsh/git-prompt"
_source_os "$DOTFILES_PATH/zsh/history"
_source_os "$DOTFILES_PATH/zsh/keybind"
_source_os "$DOTFILES_PATH/zsh/plugin"
_source_os "$DOTFILES_PATH/zsh/prompt"
_source_os "$DOTFILES_PATH/zsh/tools"
_source_os "$DOTFILES_PATH/zsh/worktree"

_source_os "$DOTFILES_PATH/zsh/env"
