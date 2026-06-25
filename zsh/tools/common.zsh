# anyenv
if command -v anyenv 1>/dev/null 2>&1 && [[ -z "${NODENV_ROOT:-}" ]]; then
  eval "$(anyenv init -)"
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
