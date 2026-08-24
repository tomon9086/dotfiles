export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/opt/homebrew/opt/zip/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME" "${path[@]:#$PNPM_HOME}")
