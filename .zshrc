export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/home/tomo/.custom-commands

HISTFILE=/home/tomo/.zsh_history
HISTSIZE=2000
SAVEHIST=1000

setopt magic_equal_subst
# setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt prompt_subst

# .swp tab補完無視
zstyle ':completion:*:*files' ignored-patterns '*.swp'
# git関係表示 check-for-changes trueが重いかも…
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

alias ls='ls --color=auto'
alias chrome='google-chrome'

autoload -U compinit
compinit
autoload -Uz colors
colors
autoload -Uz vcs_info

# environment variables
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

# zplug
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

# prompt
# export PREV_EXITSTAT=😄
# PROMPT="${PREV_EXITSTAT} %B%{${fg[green]}%}%n@%m%{${reset_color}%}%b:%B%{${fg[blue]}%}%~%{${reset_color}%}%b$ "
PROMPT="%B%{${fg[green]}%}%n@%m%{${reset_color}%}%b:%B%{${fg[blue]}%}%~%{${reset_color}%}%b$ "
RPROMPT='${vcs_info_msg_0_}'

# call on every commands
preexec() {
	cmd=`echo $1 | sed s/sudo\ //g | tr ' ' '\n' | head -n 1`
	if [ -z ${cmd} ]; then
		cmd='zsh'
	fi	
	echo -ne "\033]2;${PWD##*/} - ${cmd}\007"
}
precmd() {
	vcs_info
	# echo -ne "\033]00;37${USER}@${HOST%%.*}:${PWD}\007"
	cmd=`ps $$ | tr ' ' '\n' | tail -n 1`
	echo -ne "\033]2;${PWD##*/} - ${cmd}\007"
	# if [ $? -eq 0 ]; then
	#	PREV_EXITSTAT=😄
	# else
	#	PREV_EXITSTAT=😕
	# fi
}
