# anyenv
if command -v anyenv 1>/dev/null 2>&1 && [[ -z "${DOTFILES_ANYENV_INITIALIZED:-}" ]]; then
  eval "$(anyenv init -)"
  export DOTFILES_ANYENV_INITIALIZED=1
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# platformio
if [[ -x "$HOME/.platformio/penv/bin/pio" ]]; then
  export PATH="$HOME/.platformio/penv/bin:$PATH"
fi
