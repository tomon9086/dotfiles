source ~/.zplug/init.zsh
# source ~/.dotfiles/.git-completion
source ~/.dotfiles/.git-prompt

zplug "wbinglee/zsh-wakatime"

# git関係表示 check-for-changes trueが重いかも…
# zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
# zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
# zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
# zstyle ':vcs_info:*' actionformats '[%b|%a]'

# syntax
zplug "chrissicool/zsh-256color"
zplug "Tarrasch/zsh-colors"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "ascii-soup/zsh-url-highlighter"

# program
zplug "voronkovich/mysql.plugin.zsh"

# autoload -Uz vcs_info

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
# export PS1="\h\[\033[00m\]:\W\[\033[31m\]$(__git_ps1 [%s])\[\033[00m\]\$ "
PROMPT="%B%{${fg[green]}%}%n@%m%{${reset_color}%}%b:%B%{${fg[blue]}%}%~%{${reset_color}%}%b$ "

# call on every commands
preexec() {
	# cmd=`echo $1 | sed s/sudo\ //g | tr ' ' '\n' | head -n 1`
	# if [ -z ${cmd} ]; then
	#	cmd='zsh'
	# fi
	# echo -ne "\033]2;${PWD##*/}\007"
}
precmd() {
	# vcs_info
	# echo -ne "\033]00;37${USER}@${HOST%%.*}:${PWD}\007"
	# cmd=`ps $$ | tr ' ' '\n' | tail -n 1`
	# echo -ne "\033]2;${PWD##*/}\007"
	RPROMPT="$(__git_ps1 [%s])"
}

