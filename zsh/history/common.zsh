setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# + command: save snippet to pet
+() {
  if ! command -v pet &>/dev/null; then
    echo "pet is not installed"
    return 1
  fi

  if [[ $# -eq 0 ]]; then
    # No arguments: save the last command
    local last_cmd=$(fc -ln -1 | sed 's/^ *//')
    if [[ -n "$last_cmd" ]]; then
      echo "Saving to pet: $last_cmd"
      pet new "$last_cmd"
    else
      echo "No previous command to save"
    fi
  else
    # Arguments provided: execute the command and save it
    local cmd_to_execute="$*"
    eval "$cmd_to_execute"
    local exit_code=$?
    echo "Saving to pet: $cmd_to_execute"
    pet new "$cmd_to_execute"
    return $exit_code
  fi
}

# Search pet snippets
function pet_search() {
  BUFFER=$(pet search --query "$LBUFFER")
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    return
  fi
  CURSOR=$#BUFFER
  zle reset-prompt
}
