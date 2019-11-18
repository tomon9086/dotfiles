DOTFILES_PATH="$HOME/.dotfiles"

source "$DOTFILES_PATH/.git-prompt"

# release lock of ^s & ^q keybinding
stty stop undef
stty start undef

# history
setopt share_history
setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# zplug
source ~/.zplug/init.zsh

# syntax
zplug "chrissicool/zsh-256color"
zplug "Tarrasch/zsh-colors"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "ascii-soup/zsh-url-highlighter"

# program
zplug "voronkovich/mysql.plugin.zsh"
zplug "wbinglee/zsh-wakatime"

# tools
zplug "marzocchi/zsh-notify"
# zplug "oknowton/zsh-dwim"
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/emoji-cli"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

export NVM_DIR="/Users/tomo/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# load nvm lazily
# nvm() {
# 	unset -f nvm
# 	source "${NVM_DIR:-$HOME/.nvm}/nvm.sh"
# 	nvm "$@"
# }

export PATH="/Users/tomo/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH="$PATH:$HOME/.pyenv/shims"
eval "$(rbenv init -)"
export PATH="$PATH:$HOME/.rbenv/shims"
export PATH=/usr/local/mecab/bin:$PATH
export PATH=/Users/tomo/.custom-commands:$PATH
export PATH=/usr/local/Cellar/gcc/8.1.0/bin:$PATH
export PATH="$PATH:$HOME/flutter/bin"

alias ls="ls -G"
alias clear="/usr/bin/clear"
alias gcc="gcc-8"
alias g++="g++-8"
alias sed="gsed"
alias xargs="gxargs"
alias mongod="mongod -dbpath /usr/local/var/mongodb"

# gibo
function gibo() {
	if [ -z "$2" ] &&  [ "dump" = "$1" ]; then
		command gibo list | sed -e 's/=== .\+ ===//g' | sed -e 's/\s\+/\n/g' | grep -v '^\s*$' | fzy | xargs -I@ gibo dump @
	else
		command gibo $*
	fi
}

# prompt
GIT_PS1_SHOWDIRTYSTATE=true
PROMPT="%B%{${fg[green]}%}%n@%m%{${reset_color}%}%b:%B%{${fg[blue]}%}%~%{${reset_color}%}%b$ "

# call on every commands
preexec() {
}
precmd() {
	RPROMPT=$(__git_ps1 "[%s]")
}


[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "/Users/tomo/.gvm/scripts/gvm" ]] && source "/Users/tomo/.gvm/scripts/gvm"

export EDITOR=/usr/bin/nano
eval "$(direnv hook zsh)"


# keybinds
# ^r
function fzy_history() {
	local cmd=$(history -n -r 1 | fzy --prompt="history > ")
	if [ -n "${cmd}" ]; then
		BUFFER="${cmd}"
	fi
	zle reset-prompt
	# zle accept-line
}
zle -N fzy_history
bindkey '^r' fzy_history

# end profiling (start command is in ~/.zshenv)
if (which zprof > /dev/null 2>&1) ;then
  zprof
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tomo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tomo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tomo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tomo/google-cloud-sdk/completion.zsh.inc'; fi
