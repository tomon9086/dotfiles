typeset -g _HISTORY_SELECT_CMD=""

function history() {
  if [[ "$#" == "0" ]]; then
    local cmd
    cmd=$(fc -rln 1 | fzy)
    if [[ -n "$cmd" ]]; then
      _HISTORY_SELECT_CMD="$cmd"
    fi
  else
    builtin history "$@"
  fi
}

# ZLE が端末を初期化した後に BUFFER へ注入する（ZLE 外で fzy を使うと編集不可になる問題の回避）
function _history_inject_zle() {
  if [[ -n "$_HISTORY_SELECT_CMD" ]]; then
    BUFFER="$_HISTORY_SELECT_CMD"
    CURSOR=$#BUFFER
    _HISTORY_SELECT_CMD=""
  fi
}
zle -N zle-line-init _history_inject_zle

function gibo() {
	if [ -z "$2" ] &&  [ "dump" = "$1" ]; then
		command gibo list | sed -e 's/=== .\+ ===//g' | sed -e 's/\s\+/\n/g' | grep -v '^\s*$' | fzy | xargs -I@ gibo dump @
	else
		command gibo $*
	fi
}
