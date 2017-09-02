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
zplug "oknowton/zsh-dwim"

export NVM_DIR="/Users/tomo/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
source /Users/tomo/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# export PATH=/Users/tomo/.pyenv/versions/3.5.2/bin:$PATH
export PATH=/Users/tomo/.pyenv/versions/2.7.1/bin:$PATH

export PATH=/Users/tomo/.custom-commands:$PATH	

alias ls="ls -G"

# prompt
GIT_PS1_SHOWDIRTYSTATE=true
PROMPT="%B%{${fg[green]}%}%n@%m%{${reset_color}%}%b:%B%{${fg[blue]}%}%~%{${reset_color}%}%b$ "

# call on every commands
preexec() {
}
precmd() {
	RPROMPT="$(__git_ps1 [%s])"
}

