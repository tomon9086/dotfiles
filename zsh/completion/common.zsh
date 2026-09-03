COMPLETION_SCRIPTS_DIR="$DOTFILES_PATH/zsh/completion"

# Add scripts dir to fpath for custom completions (_git, etc.)
fpath=("$COMPLETION_SCRIPTS_DIR/scripts" $fpath)

# Add Homebrew completions before compinit snapshots available functions.
for dir in /opt/homebrew/share/zsh/site-functions /usr/local/share/zsh/site-functions; do
  [[ -d "$dir" ]] && fpath=("$dir" $fpath)
done

# Initialize completion system
autoload -Uz compinit && compinit

# gh completion
if command -v gh 1>/dev/null 2>&1; then
  source <(gh completion -s zsh)
fi

# pnpm completion
if command -v pnpm 1>/dev/null 2>&1; then
  source "$COMPLETION_SCRIPTS_DIR/scripts/pnpm.zsh"
fi

# tabtab source for packages
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# kubectl completion
if command -v kubectl 1>/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

# terraform completion
if command -v terraform 1>/dev/null 2>&1; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "$(command -v terraform)" terraform
fi

# aws cli completion
# NOTE: aws標準の`_aws`スタブ(aws_zsh_completer.sh)はTabを1回押しただけ
# では補完登録が反映されない(2回目から効く)ため、bashcompinit経由で
# 直接aws_completerを登録する。
if command -v aws_completer 1>/dev/null 2>&1; then
  autoload -U +X bashcompinit && bashcompinit
  complete -C "$(command -v aws_completer)" aws
fi

# Angular CLI
if command -v ng 1>/dev/null 2>&1; then
  source <(ng completion script)
fi

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# pet completion
if command -v pet 1>/dev/null 2>&1; then
  source "$COMPLETION_SCRIPTS_DIR/scripts/pet.zsh"
fi
