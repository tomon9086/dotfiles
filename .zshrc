source ~/.zplug/init.zsh
source ~/.dotfiles/.git-prompt

zplug "wbinglee/zsh-wakatime"

# syntax
zplug "chrissicool/zsh-256color"
zplug "Tarrasch/zsh-colors"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "ascii-soup/zsh-url-highlighter"

# program
zplug "voronkovich/mysql.plugin.zsh"

# tools
zplug "marzocchi/zsh-notify"
# zplug "oknowton/zsh-dwim"
# zplug "b4b4r07/enhancd", use:init.sh

export NVM_DIR="/Users/tomo/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

source /Users/tomo/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/.pyenv/shims:$PATH"

export PATH=/usr/local/mecab/bin:$PATH

export PATH=/Users/tomo/.custom-commands:$PATH	

alias ls="ls -G"
alias clear="/usr/bin/clear"

# prompt
GIT_PS1_SHOWDIRTYSTATE=true
PROMPT="%B%{${fg[green]}%}%n@%m%{${reset_color}%}%b:%B%{${fg[blue]}%}%~%{${reset_color}%}%b$ "

# call on every commands
preexec() {
}
precmd() {
	RPROMPT="$(__git_ps1 [%s])"
}

