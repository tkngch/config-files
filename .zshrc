
#------------------------------
# History
#------------------------------
HISTFILE=$HOME/.cache/zsh.hist
HISTSIZE=1000
SAVEHIST=1000
# ignore duplicate
# setopt histignorealldups

LESSHISTFILE=$HOME/.cache/less.hist

#------------------------------
## Variables
##------------------------------
export TERM="xterm-256color"
export BROWSER="/bin/chromium"
export EDITOR="/bin/vim"
export PATH="${PATH}:${HOME}/bin"
export VISUAL="/bin/vim"
export PAGER="/bin/less"
export LESS="-r"  # color support
export DISPLAY=:0.0
export PYTHONPATH="$HOME/lib/python/"
export PYTHONUSERBASE="$HOME/lib/python/"  # directory for pip -user
export XDG_CONFIG_HOME="$HOME/.config"
export MATPLOTLIBRC="$HOME/.config/matplotlib/"
export R_LIBS_USER="$HOME/lib/R/"
# color grep output
export GREP_COLOR='1;33'  # yellow
# export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:$HOME/lib/cpp/:/usr/include/"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib/cpp/"


#------------------------------
## Keybindings
##------------------------------
bindkey -v
typeset -g -A key
#bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
#bindkey '\e[2~' overwrite-mode
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for gnome-terminal
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# history search with arrow keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# history search with j and k in normal mode
bindkey -M vicmd "k" history-beginning-search-backward
bindkey -M vicmd "j" history-beginning-search-forward


#------------------------------
# Auto completion
#------------------------------
autoload -Uz compinit
compinit -d $HOME/.cache/zsh.compdump
# move the cursor around the list of completions to select one
zstyle ':completion:*' menu select
# This way you tell zsh comp to take the first part of the path to be exact,
# and to avoid partial globs. Now path completions became nearly immediate.
zstyle ':completion:*' accept-exact '*(N)'
# autocomplete aliases
setopt completealiases


#------------------------------
# Window title
#------------------------------
case $TERM in
    termite|*xterm*|rxvt*)
        precmd () { print -Pn '\e]0;%n@%m:%4d\a' }
        ;;
esac


#------------------------------
# Prompt
#------------------------------

PROMPT='
%F{white}%d
%B%F{magenta}>%F{yellow}>%F{blue}>%b%F{white} '

function indicate_mode {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
}
indicate_mode

function zle-line-init zle-keymap-select {
    indicate_mode
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


#------------------------------
# Dirstack
#------------------------------
DIRSTACKFILE="$HOME/.cache/zsh.dirs"
DIRSTACKSIZE=10
setopt autopushd pushdsilent pushdtohome
# remove duplicate entries
setopt pushdignoredups
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}


#------------------------------
# Aliases
#------------------------------
alias ls='/bin/ls --color=auto'
# alias l='ls -Alh'
alias ds='dirs -v'
alias dic='sdcv'
alias mkdir='mkdir -v'
alias mv='mv -iv'
alias cp='cp -i -p'
alias rm='rm -iv'
alias handbrake='ghb'
alias qtpython='ipython qtconsole'
alias R='$HOME/bin/R'
alias grep='grep --color=always'
alias matlab='LD_LIBRARY_PATH="/home/takao/etc/matlab_libs/" /usr/local/bin/matlab -nosplash -nodesktop'


#------------------------------
# Misc
#------------------------------
unsetopt beep

# disable XON/XOFF flow control (^s/^q)
stty -ixon

# activate zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
