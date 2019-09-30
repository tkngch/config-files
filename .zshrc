# .zshrc

# History in cache directory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.cache/zsh.hist

# Environment variables
export TERM="xterm-256color"
export BROWSER=""
export EDITOR="/bin/vim"
export SYSTEMD_EDITOR="/bin/vim"
export PATH="${HOME}/bin:${PATH}"
export VISUAL="/bin/vim"
export PAGER="/bin/less"
export LESS="-r"  # color support
export LESSHISTFILE=$HOME/.cache/less.hist
export PYTHONPATH="$HOME/lib/python/"
export PYTHONUSERBASE="$HOME/lib/python/"  # directory for pip -user
export XDG_CONFIG_HOME="$HOME/.config"
export MATPLOTLIBRC="$HOME/.config/matplotlib/"
export R_LIBS_USER="$HOME/lib/R/"
export R_PROFILE_USER="$HOME/.Rprofile"
export R_DEFAULT_PACKAGES=NULL  # do not let R preload anything
export GREP_COLOR='1;33'  # color grep output in yellow
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib/cpp/"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export STARDICT_DATA_DIR="$HOME/var/stardict/dic"
export GTK_IM_MODULE=fcitx  # support fcitx
export QT_IM_MODULE=fcitx  # support fcitx
export XMODIFIERS=@im=fcitx  # support fcitx
export KEYTIMEOUT=1  # 10ms after Esc key press before entering the normal mode in zsh

# Keybindings
bindkey -v  # use vi mode
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
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
## for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
## for gnome-terminal
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
## history search with arrow keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
## history search with j and k in normal mode
bindkey -M vicmd "k" history-beginning-search-backward
bindkey -M vicmd "j" history-beginning-search-forward

# Auto completion
autoload -Uz compinit
compinit -d $HOME/.cache/zsh.compdump
# move the cursor around the list of completions to select one
zstyle ':completion:*' menu select
# This way you tell zsh comp to take the first part of the path to be exact,
# and to avoid partial globs. Now path completions became nearly immediate.
zstyle ':completion:*' accept-exact '*(N)'
# When completing for openpdf script, match only *.pdf files.
zstyle ":completion:*:*:openpdf:*" file-patterns "*.pdf *(-/)"
# autocomplete aliases
setopt completealiases

# Command editing
# edit a command in vim with ctrl-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Dirstack
DIRSTACKFILE="$HOME/.cache/zsh.dirs"
DIRSTACKSIZE=10
setopt autopushd pushdsilent pushdtohome
## remove duplicate entries
setopt pushdignoredups
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

# Aliases
alias ls='/bin/ls --color=auto'
alias mkdir='mkdir -v'
alias mv='mv -iv'
alias cp='cp -i -p'
alias rm='rm -iv'
alias handbrake='ghb'
alias grep='grep --color=always'

# Print the elapsed time after a long process
autoload -Uz vcs_info
preexec () {
    # Note the date when the command started, in unix time.
    CMD_START_DATE=$(date +%s)
    # Store the command that we're running.
    CMD_NAME=$1
}

precmd () {
    vcs_info

    # Proceed only if we've ran a command in the current shell.
    if ! [[ -z $CMD_START_DATE ]]; then
        # Note current date in unix time
        CMD_END_DATE=$(date +%s)
        # Store the difference between the last command start date vs. current date.
        CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))
        # Store an arbitrary threshold, in seconds.
        CMD_NOTIFY_THRESHOLD=10

        if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
            # print elapsed time if the elapsed time (in seconds) is greater than threshold
            echo -e ""
            echo -e "---"
            hours=$(($CMD_ELAPSED_TIME / 3600))
            remaining_seconds=$(($CMD_ELAPSED_TIME % 3600))
            minutes=$(($remaining_seconds / 60))
            seconds=$(($remaining_seconds % 60))

            output="Elapsed time:"
            if [[ $hours -gt 1 ]]; then
                output="${output} ${hours} hours"
            elif [[ $hours -gt 0 ]]; then
                output="${output} ${hours} hour"
            fi

            if [[ $minutes -gt 1 ]]; then
                output="${output} ${minutes} minutes and"
            elif [[ $hours -gt 0 ]]; then
                output="${output} ${minutes} minute and"
            fi

            if [[ $seconds -gt 1 ]]; then
                output="${output} ${seconds} seconds"
            else
                output="${output} ${minutes} second"
            fi

            echo -e "\033[0m${output}.\033[0m"
        fi
    fi
    echo -e ""
}

# Prompt
## Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats 'branch:%b'
setopt PROMPT_SUBST
PROMPT='${vcs_info_msg_0_}
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

# Misc
unsetopt beep

## disable XON/XOFF flow control (^s/^q)
stty -ixon

## activate zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
