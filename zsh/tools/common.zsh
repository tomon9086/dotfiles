# anyenv
# Note: always re-run (no "already in PATH" guard) so anyenv's shims stay
# ahead of Homebrew's PATH entries even in shells that inherit PATH from an
# already-initialized parent (tmux panes, nested shells, etc.), since
# brew shellenv above unconditionally re-prepends itself every time too.
if command -v anyenv 1>/dev/null 2>&1; then
  eval "$(anyenv init -)"
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# platformio
if [[ -x "$HOME/.platformio/penv/bin/pio" && "$PATH" != *"$HOME/.platformio/penv/bin"* ]]; then
  export PATH="$HOME/.platformio/penv/bin:$PATH"
fi
