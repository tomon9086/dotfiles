# anyenv
if command -v anyenv 1>/dev/null 2>&1 && [[ "$PATH" != *"$(anyenv root)"* ]]; then
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
