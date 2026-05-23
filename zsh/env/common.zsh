# PATH
export PATH="$HOME/go/bin:$PATH"
export PATH="$DENO_INSTALL/bin:$PATH"
export PATH="$DVM_DIR/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.custom-commands:$PATH"
export PATH="$HOME/.gem/bin:$PATH"
export PATH="$HOME/flutter/bin:$PATH"

# tools
export DENO_INSTALL="$HOME/.deno"
export DVM_DIR="$HOME/.dvm"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# yarn
if command -v yarn 1>/dev/null 2>&1; then
  export PATH="$(yarn global bin):$PATH"
fi

# serverless
export PATH="$HOME/.serverless/bin:$PATH"

# difft
if command -v difft 1>/dev/null 2>&1; then
  export GIT_EXTERNAL_DIFF=difft
fi

# pet
if command -v pet 1>/dev/null 2>&1 && command -v gh 1>/dev/null 2>&1; then
  export PET_GITHUB_ACCESS_TOKEN=$(gh auth token)
fi
